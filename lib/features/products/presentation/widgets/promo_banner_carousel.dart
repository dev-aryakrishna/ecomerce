import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ecomerceapp/core/theme/app_radius.dart';
import 'package:ecomerceapp/core/theme/app_shadows.dart';
import 'package:ecomerceapp/l10n/app_localizations.dart';

class _Banner {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  const _Banner(this.title, this.subtitle, this.icon, this.gradient);
}

class PromoBannerCarousel extends StatefulWidget {
  const PromoBannerCarousel({super.key});

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  final _controller = PageController();
  Timer? _timer;
  int _index = 0;

  static const _bannerCount = 3;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_controller.hasClients) return;
      _index = (_index + 1) % _bannerCount;
      _controller.animateToPage(
        _index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final banners = [
      _Banner(
        l10n.bigSale,
        l10n.acrossTop,
        Icons.local_fire_department_rounded,
        const [Color(0xFFFF6584), Color(0xFFEF4444)],
      ),
      _Banner(
        l10n.arrivals,
        l10n.fresh,
        Icons.auto_awesome_rounded,
        const [Color(0xFF6C63FF), Color(0xFF4F46E5)],
      ),
      _Banner(
        l10n.topRated,
        l10n.highly,
        Icons.star_rounded,
        const [Color(0xFFF59E0B), Color(0xFFEA580C)],
      ),
    ];
    return Column(
      children: [
        SizedBox(
          height: 128,
          child: PageView.builder(
            controller: _controller,
            itemCount: banners.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              final banner = banners[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.lgRadius,
                    gradient: LinearGradient(
                      colors: banner.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: AppShadows.card,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                banner.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                banner.subtitle,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.92),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(banner.icon, color: Colors.white.withOpacity(0.85), size: 44),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _index == i ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _index == i ? banners[i].gradient.first : Colors.grey.shade300,
                borderRadius: AppRadius.pillRadius,
              ),
            ),
          ),
        ),
      ],
    );
  }
}