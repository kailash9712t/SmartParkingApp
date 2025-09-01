import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpart/Page/SelectCoords/State/select_coords.dart';
import 'package:smartpart/Page/UploadImage/State/upload_image.dart';

class DraggableIndicatorImage extends StatefulWidget {
  const DraggableIndicatorImage({super.key});

  @override
  State<DraggableIndicatorImage> createState() =>
      _DraggableIndicatorImageState();
}

class _DraggableIndicatorImageState extends State<DraggableIndicatorImage> {
  Offset _point = const Offset(50, 50);
  ui.Image? _image;
  Size _imageSize = Size.zero;
  Size _displaySize = Size.zero;
  bool _isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadImage(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload image if the file changes
    final file = context.watch<UploadImageModel>().file;
    if (file != null && !_isImageLoaded) {
      _loadImage(context);
    }
  }

  Future<void> _loadImage(BuildContext context) async {
    try {
      final file = context.read<UploadImageModel>().file;
      if (file != null && await file.exists()) {
        final bytes = await file.readAsBytes();
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();

        if (mounted) {
          setState(() {
            _image = frame.image;
            _imageSize = Size(
              frame.image.width.toDouble(),
              frame.image.height.toDouble(),
            );
            context.read<SelectCoordsModel>().imageCoords = [
              frame.image.width.toDouble(),
              frame.image.height.toDouble(),
            ];
            _isImageLoaded = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading image: $e');
      if (mounted) {
        setState(() {
          _isImageLoaded = false;
          _imageSize = Size.zero;
        });
      }
    }
  }

  // Calculate the display size that maintains aspect ratio within available space
  Size _calculateDisplaySize(Size imageSize, Size availableSize) {
    if (imageSize.width == 0 || imageSize.height == 0) {
      return Size(300, 300); // Larger default size when image not loaded
    }

    final imageAspectRatio = imageSize.width / imageSize.height;
    final availableAspectRatio = availableSize.width / availableSize.height;

    double displayWidth, displayHeight;

    if (imageAspectRatio > availableAspectRatio) {
      // Image is wider - fit to width, use 90% of available space
      displayWidth = availableSize.width * 0.9;
      displayHeight = displayWidth / imageAspectRatio;
    } else {
      // Image is taller - fit to height, use 90% of available space
      displayHeight = availableSize.height * 0.9;
      displayWidth = displayHeight * imageAspectRatio;
    }

    // Ensure minimum size for usability
    displayWidth = displayWidth.clamp(300.0, availableSize.width);
    displayHeight = displayHeight.clamp(300.0, availableSize.height);

    return Size(displayWidth, displayHeight);
  }

  // Convert widget coordinates to actual image pixel coordinates
  Offset _getImageCoordinates(
    Offset widgetCoords,
    Size displaySize,
    Size imageSize,
  ) {
    if (displaySize.width == 0 ||
        displaySize.height == 0 ||
        imageSize.width == 0 ||
        imageSize.height == 0) {
      return Offset.zero;
    }

    // For BoxFit.contain, the scaling is uniform
    final scale = displaySize.width / imageSize.width;

    // Convert widget coordinates to image coordinates
    double imageX = widgetCoords.dx / scale;
    double imageY = widgetCoords.dy / scale;

    // Clamp to image bounds (ensure coordinates stay within image)
    imageX = imageX.clamp(0.0, imageSize.width - 1);
    imageY = imageY.clamp(0.0, imageSize.height - 1);

    return Offset(imageX, imageY);
  }

  Widget _buildCoordinateText(Offset imageCoords) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 200, // Prevent text from expanding beyond screen
        maxHeight: 80,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Widget: (${_point.dx.toInt()}, ${_point.dy.toInt()})",
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          if (_isImageLoaded && _imageSize != Size.zero) ...[
            Text(
              "Image: (${imageCoords.dx.toInt()}, ${imageCoords.dy.toInt()})",
              style: const TextStyle(
                color: Colors.cyan,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "Size: ${_imageSize.width.toInt()}×${_imageSize.height.toInt()}",
              style: const TextStyle(color: Colors.white70, fontSize: 9),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "Display: ${_displaySize.width.toInt()}×${_displaySize.height.toInt()}",
              style: const TextStyle(color: Colors.green, fontSize: 9),
              overflow: TextOverflow.ellipsis,
            ),
          ] else
            const Text(
              "Loading...",
              style: TextStyle(color: Colors.orange, fontSize: 10),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final file = context.watch<UploadImageModel>().file;

    // Safety check for file existence
    if (file == null) {
      return Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[300],
        ),
        child: const Center(
          child: Text(
            'No image selected',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Ensure we have valid constraints with larger minimum sizes
        final availableSize = Size(
          constraints.maxWidth.isFinite ? constraints.maxWidth : 600,
          constraints.maxHeight.isFinite ? constraints.maxHeight : 600,
        );

        // Calculate the actual display size maintaining aspect ratio
        _displaySize = _calculateDisplaySize(_imageSize, availableSize);

        // Get actual image pixel coordinates
        final imageCoords =
            _isImageLoaded && _imageSize != Size.zero
                ? _getImageCoordinates(_point, _displaySize, _imageSize)
                : Offset.zero;

        // Calculate safe positioning for coordinate text
        final textLeft =
            (_point.dx + 20 + 200 > _displaySize.width)
                ? _point.dx -
                    220 // Show on left if it would overflow right
                : _point.dx + 20;
        final textTop =
            (_point.dy + 100 > _displaySize.height)
                ? _point.dy -
                    110 // Show above if it would overflow bottom
                : _point.dy - 10;

        return Center(
          child: SizedBox(
            width: _displaySize.width,
            height: _displaySize.height,
            child: Stack(
              clipBehavior: Clip.hardEdge, // Prevent overflow
              children: [
                // Display the image
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      file,
                      fit:
                          BoxFit
                              .contain, // Changed to contain to show full image
                      width: _displaySize.width,
                      height: _displaySize.height,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.red[100],
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.error, color: Colors.red, size: 48),
                                SizedBox(height: 8),
                                Text(
                                  'Error loading image',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Draggable indicator with strict boundary constraints
                Positioned(
                  left: (_point.dx - 15).clamp(0, _displaySize.width - 30),
                  top: (_point.dy - 15).clamp(0, _displaySize.height - 30),
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        // Calculate new position with strict image boundaries
                        double newX = _point.dx + details.delta.dx;
                        double newY = _point.dy + details.delta.dy;

                        // Ensure indicator stays within image bounds (not just display bounds)
                        double x = newX.clamp(15.0, _displaySize.width - 15.0);
                        double y = newY.clamp(15.0, _displaySize.height - 15.0);

                        // Account for the circle radius (15) so the entire circle stays visible
                        _point = Offset(x, y);

                        context.read<SelectCoordsModel>().setCoords(
                          imageCoords.dx,
                          imageCoords.dy,
                        );
                      });
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Coordinates text with safe positioning
                Positioned(
                  left: textLeft.clamp(0, _displaySize.width - 200),
                  top: textTop.clamp(0, _displaySize.height - 100),
                  child: _buildCoordinateText(imageCoords),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _image?.dispose();
    super.dispose();
  }
}
