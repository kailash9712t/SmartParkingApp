from ultralytics import YOLO
import matplotlib.pyplot as plt
import math
from typing import List, Tuple, Optional
from enum import Enum
from PIL import Image


class ExperienceLevel(Enum):
    BEGINNER = "beginner"
    INTERMEDIATE = "intermediate"
    EXPERT = "expert"


class ParkingSpotDetector:
    
    def __init__(self, model_path: str, entrance_coords: Tuple[int, int], exit_coords: Tuple[int, int], result,filename, device_pixel):
        self.results = result 
        self.model = YOLO(model_path)
        self.entrance_coords = entrance_coords
        self.exit_coords = exit_coords
        self.free_spaces = []
        self.parking_data = []
        self.filename = filename
        self.device_pixel = device_pixel
    
    def detect_parking_spaces(self, image_path: str, confidence: float = 0.5) -> List[List[float]]:
        self.results = self.model(image_path, conf=confidence)
        detected_boxes = self.results[0].boxes.data.tolist()
        self.free_spaces = [box for box in detected_boxes if box[5] == 1.0]
        return self.free_spaces
    
    def calculate_box_centers(self) -> List[Tuple[float, float]]:
        centers = []
        for box in self.free_spaces:
            x1, y1, x2, y2 = box[0], box[1], box[2], box[3]
            center_x = (x1 + x2) / 2
            center_y = (y1 + y2) / 2
            centers.append((center_x, center_y))
        return centers
    
    def calculate_distances(self) -> List[dict]:
        centers = self.calculate_box_centers()
        parking_data = []
        
        for i, (center_x, center_y) in enumerate(centers):
            entrance_dist = math.sqrt(
                (center_x - self.entrance_coords[0]) ** 2 + 
                (center_y - self.entrance_coords[1]) ** 2
            )
            
            exit_dist = math.sqrt(
                (center_x - self.exit_coords[0]) ** 2 + 
                (center_y - self.exit_coords[1]) ** 2
            )
            
            space_width = abs(self.free_spaces[i][2] - self.free_spaces[i][0])
            space_height = abs(self.free_spaces[i][3] - self.free_spaces[i][1])
            space_area = space_width * space_height
            
            is_corner = self._is_corner_spot(center_x, center_y)
            is_near_wall = self._is_near_wall(center_x, center_y)
            
            parking_data.append({
                'spot_id': i,
                'coordinates': (center_x, center_y),
                'entrance_distance': entrance_dist,
                'exit_distance': exit_dist,
                'total_distance': entrance_dist + exit_dist,
                'space_area': space_area,
                'space_width': space_width,
                'is_corner': is_corner,
                'is_near_wall': is_near_wall,
                'difficulty_score': self._calculate_difficulty(space_area, is_corner, is_near_wall)
            })
        
        self.parking_data = parking_data
        return parking_data
    
    def _is_corner_spot(self, x: float, y: float) -> bool:
        img_width, img_height = 640, 480
        corner_threshold = 50
        return (x < corner_threshold or x > img_width - corner_threshold or
                y < corner_threshold or y > img_height - corner_threshold)
    
    def _is_near_wall(self, x: float, y: float) -> bool:
        img_width, img_height = 640, 480
        wall_threshold = 30
        return (x < wall_threshold or x > img_width - wall_threshold or
                y < wall_threshold or y > img_height - wall_threshold)
    
    def _calculate_difficulty(self, area: float, is_corner: bool, is_near_wall: bool) -> float:
        base_difficulty = max(0, 10 - (area / 1000))
        if is_corner:
            base_difficulty -= 2
        if is_near_wall:
            base_difficulty -= 1
        return max(0, min(10, base_difficulty))
    
    def find_best_spot(self, 
                      experience: ExperienceLevel = ExperienceLevel.INTERMEDIATE,
                      prefer_entrance: bool = False, 
                      prefer_exit: bool = False,
                      has_mobility_issues: bool = False) -> Optional[int]:
        if not self.parking_data:
            return None
        
        scored_spots = []
        
        for spot in self.parking_data:
            score = self._calculate_personalized_score(
                spot, experience, prefer_entrance, prefer_exit, has_mobility_issues
            )
            scored_spots.append({
                'spot_id': spot['spot_id'],
                'score': score,
                'reasoning': self._get_recommendation_reasoning(spot, experience)
            })
        
        scored_spots.sort(key=lambda x: x['score'])
        best_spot = scored_spots[0]
        
        print(f"Recommended spot reasoning: {best_spot['reasoning']}")
        return best_spot['spot_id']
    
    def _calculate_personalized_score(self, 
                                    spot: dict, 
                                    experience: ExperienceLevel,
                                    prefer_entrance: bool,
                                    prefer_exit: bool,
                                    has_mobility_issues: bool) -> float:
        score = 0.0
        
        if experience == ExperienceLevel.BEGINNER:
            score += spot['difficulty_score'] * 3.0
            score += spot['entrance_distance'] * 0.2
            if spot['is_corner'] or spot['is_near_wall']:
                score -= 20
            if spot['space_area'] > 2000:
                score -= 15
        elif experience == ExperienceLevel.EXPERT:
            score += spot['difficulty_score'] * 0.5
            score += spot['total_distance'] * 0.2
        else:
            score += spot['difficulty_score'] * 1.5
            score += spot['entrance_distance'] * 0.15
            if spot['is_corner']:
                score -= 5
        
        if has_mobility_issues:
            score += spot['entrance_distance'] * 0.6
            score += spot['difficulty_score'] * 2.5
            if spot['is_corner']:
                score -= 15
        
        if prefer_entrance:
            score += spot['entrance_distance'] * 0.4
        if prefer_exit:
            score += spot['exit_distance'] * 0.4
        
        if prefer_entrance and prefer_exit:
            balance = abs(spot['entrance_distance'] - spot['exit_distance'])
            score += balance * 0.3
        
        return score
    
    def _get_recommendation_reasoning(self, spot: dict, experience: ExperienceLevel) -> str:
        reasons = []
        
        if spot['is_corner']:
            reasons.append("corner spot (easier maneuvering)")
        if spot['space_area'] > 2000:
            reasons.append("large space")
        if spot['entrance_distance'] < 100:
            reasons.append("close to entrance")
        if spot['difficulty_score'] < 3:
            reasons.append("low difficulty")
        
        if experience == ExperienceLevel.BEGINNER:
            reasons.append("suitable for beginner driver")
        elif experience == ExperienceLevel.EXPERT:
            reasons.append("convenient for experienced driver")
        
        return f"Selected for: {', '.join(reasons) if reasons else 'best available option'}"
    
    def _find_balanced_spot(self) -> int:
        balanced_spots = []
        
        for spot in self.parking_data:
            distance_difference = abs(spot['entrance_distance'] - spot['exit_distance'])
            balanced_spots.append({
                'spot_id': spot['spot_id'],
                'balance_score': distance_difference
            })
        
        balanced_spots.sort(key=lambda x: x['balance_score'])
        return balanced_spots[0]['spot_id']
    
    def visualize_results(self, image_path: str, best_spot_id: Optional[int] = None):
        img = plt.imread(image_path)
        plt.figure(figsize=(12, 8))
        plt.imshow(img)
        
        for spot in self.parking_data:
            x, y = spot['coordinates']
            color = 'red' if spot['spot_id'] == best_spot_id else 'blue'
            weight = 'bold' if spot['spot_id'] == best_spot_id else 'normal'
            
            plt.text(x, y, f"{spot['spot_id']}", 
                    fontsize=35, color=color, weight=weight,
                    bbox=dict(boxstyle="round,pad=0.6", facecolor='white', alpha=1))
        
        plt.scatter(*self.entrance_coords, color='green', s=100, marker='s', label='Entrance')
        plt.scatter(*self.exit_coords, color='orange', s=100, marker='s', label='Exit')
        
        plt.legend() 
        plt.title('Parking Spot Detection and Recommendation')
        plt.axis('off')
        plt.savefig(f"images/{self.filename}_output.png")
    
    def get_spot_info(self, spot_id: int) -> Optional[dict]:
        for spot in self.parking_data:
            if spot['spot_id'] == spot_id:
                return spot
        return None


    def start(self, entrance , exit,experience, file_path):
        print("here we go")
        # detector = ParkingSpotDetector(
        #     model_path="static/model.pt",
        #     entrance_coords=entrance_coords,
        #     exit_coords=exit_coords,
        #     result=None
        # )
        
        self.detect_parking_spaces(file_path, confidence=0.5)
        self.calculate_distances()
        
        print("=== Personalized Parking Recommendations ===\n")

        case = {
                "profile": "Beginner Driver",
                "experience": experience,
                "preferences": {"prefer_entrance": entrance,"prefer_exit" : exit}
            }
        
        recommendations = {}
        
        print(f"👤 {case['profile']}:")
        best_spot = self.find_best_spot(
            experience=case['experience'],
            **case['preferences']
        )
            
        if best_spot is not None:
            spot_info = self.get_spot_info(best_spot)
            print(f"   Recommended Spot: #{best_spot}")
            print(f"   Location: ({spot_info['coordinates'][0]:.1f}, {spot_info['coordinates'][1]:.1f})")
            print(f"   Distance to entrance: {spot_info['entrance_distance']:.1f}")
            print(f"   Difficulty score: {spot_info['difficulty_score']:.1f}/10")
            print(f"   Space area: {spot_info['space_area']:.0f} sq units")
                
            recommendations[case['profile']] = best_spot
        else:
            print("   No suitable spots available")
        print()

        slot = -1
            
        
        print("=== Recommendation Summary ===")
        for profile, spot_id in recommendations.items():
            print(f"{profile}: Spot #{spot_id}")
            slot = spot_id

        
        if recommendations:
            first_recommendation = list(recommendations.values())[0]
            self.visualize_results(file_path, first_recommendation)

        print(f"results {self.results}")
        
        print("\n=== Detailed Spot Analysis ===")
        for spot in self.parking_data:
            print(f"Spot #{spot['spot_id']}:")
            print(f"  Difficulty: {spot['difficulty_score']:.1f}/10")
            print(f"  Area: {spot['space_area']:.0f}")
            print()
        
        return slot
  