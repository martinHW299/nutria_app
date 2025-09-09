import 'package:flutter/material.dart';

class LoadingOverlay extends StatefulWidget {
  final String message;
  final bool isVisible;

  const LoadingOverlay({
    super.key,
    required this.message,
    required this.isVisible,
  });

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.isVisible) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(LoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _animationController.repeat(reverse: true);
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated loading icon
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _opacityAnimation.value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.asset(
                                'assets/icons/app_icon.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Loading dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        final delay = index * 0.2;
                        final progress =
                            (_animationController.value + delay) % 1.0;
                        final opacity =
                            (progress > 0.5) ? 1.0 - progress : progress;

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: Opacity(
                            opacity: opacity * 2,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),

                const SizedBox(height: 24),

                // Message
                Text(
                  widget.message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'Esto puede tomar unos segundos...',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
