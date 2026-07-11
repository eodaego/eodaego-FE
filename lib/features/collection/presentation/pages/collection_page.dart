import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/mock/mock_dogam.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../../../core/widgets/dogam_card.dart';
import '../../../../router/route_paths.dart';

/// 도감 (CATALOG-01~03) — 필터·검색·3열 그리드.
class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  DogamCategory? _filter; // null = 전체
  String _query = '';

  List<MockDogamItem> get _visible => mockDogamItems
      .where((e) =>
          (_filter == null || e.category == _filter) &&
          (_query.isEmpty || e.name.contains(_query)))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    '도감',
                    style: AppTextStyles.display19
                        .copyWith(color: AppColors.ink),
                  ),
                  SizedBox(width: 8.w),
                  AppBadge(
                    label: '$mockDogamCollected/$mockDogamTotal',
                    background: AppColors.primaryTint,
                    foreground: AppColors.primaryDark,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryChip(
                      label: '전체',
                      selected: _filter == null,
                      onTap: () => setState(() => _filter = null),
                    ),
                    for (final c in DogamCategory.values) ...[
                      SizedBox(width: 8.w),
                      CategoryChip(
                        label: c.label,
                        selected: _filter == c,
                        color: c.color,
                        onTap: () => setState(() => _filter = c),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                onChanged: (v) => setState(() => _query = v.trim()),
                style: AppTextStyles.body15.copyWith(color: AppColors.ink),
                decoration: InputDecoration(
                  hintText: '이름으로 찾기',
                  hintStyle: AppTextStyles.body15
                      .copyWith(color: AppColors.disabled),
                  prefixIcon:
                      const Icon(Icons.search, color: AppColors.muted),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    borderSide: const BorderSide(color: AppColors.line),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3 / 3.6,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 10.w,
                  ),
                  itemCount: _visible.length,
                  itemBuilder: (context, index) {
                    final item = _visible[index];
                    return DogamCard(
                      key: ValueKey(item.id),
                      item: item,
                      onTap: () => context
                          .push(RoutePaths.collectionDetail(item.id)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
