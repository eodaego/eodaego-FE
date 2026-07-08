import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';
import '../../constants/spacing_and_radius.dart';
import '../../constants/text_styles.dart';

/// 이용약관·개인정보처리방침·위치정보 약관 등 법적 문서 열람 페이지.
///
/// `assets/legals/`의 JSON을 로드해 표시한다.
/// JSON 스키마:
/// ```json
/// { "sections": [
///     { "heading": "...", "content": "...",
///       "items": [ { "text": "...", "subItems": ["...", "..."] } ] }
/// ] }
/// ```
class LegalDocumentPage extends StatefulWidget {
  const LegalDocumentPage({
    super.key,
    required this.title,
    required this.assetPath,
  });

  /// 앱바 제목.
  final String title;

  /// JSON 자산 경로 (예: `assets/legals/terms_of_service.json`).
  final String assetPath;

  @override
  State<LegalDocumentPage> createState() => _LegalDocumentPageState();
}

class _LegalDocumentPageState extends State<LegalDocumentPage> {
  Map<String, dynamic>? _document;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    try {
      final jsonString = await rootBundle.loadString(widget.assetPath);
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          _document = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('⚠️ [LegalDocumentPage] JSON 로드 실패: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        backgroundColor: AppColors.canvas,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: AppTextStyles.display19.copyWith(color: AppColors.ink),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _document == null
            ? Center(
                child: Text(
                  '문서를 불러오지 못했어요.',
                  style: AppTextStyles.body15.copyWith(color: AppColors.muted),
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg.w,
                  vertical: AppSpacing.base.h,
                ),
                child: _buildSections(),
              ),
      ),
    );
  }

  Widget _buildSections() {
    final sections = (_document!['sections'] as List<dynamic>?) ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < sections.length; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.xl.h),
          _buildSection(sections[i] as Map<String, dynamic>),
        ],
        // 안드로이드 제스처 내비게이션 영역과 마지막 본문이 겹치지 않도록 여백.
        SizedBox(height: AppSpacing.xxl.h),
      ],
    );
  }

  Widget _buildSection(Map<String, dynamic> section) {
    final heading = section['heading'] as String? ?? '';
    final content = section['content'] as String? ?? '';
    final items = (section['items'] as List<dynamic>?) ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading.isNotEmpty) ...[
          Text(
            heading,
            style: AppTextStyles.label16Semibold.copyWith(color: AppColors.ink),
          ),
          SizedBox(height: AppSpacing.sm.h),
        ],
        if (content.isNotEmpty)
          Text(
            content,
            style: AppTextStyles.body15.copyWith(
              color: AppColors.ink,
              height: 1.6,
            ),
          ),
        if (items.isNotEmpty) ...[
          if (content.isNotEmpty) SizedBox(height: AppSpacing.sm.h),
          for (final item in items) _buildItem(item as Map<String, dynamic>),
        ],
      ],
    );
  }

  Widget _buildItem(Map<String, dynamic> item) {
    final text = item['text'] as String? ?? '';
    final subItems = (item['subItems'] as List<dynamic>?) ?? [];

    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.xs.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: AppTextStyles.body15.copyWith(
              color: AppColors.ink,
              height: 1.6,
            ),
          ),
          if (subItems.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.base.w,
                top: AppSpacing.xs.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final subItem in subItems)
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Text(
                        subItem.toString(),
                        style: AppTextStyles.caption14.copyWith(
                          color: AppColors.muted,
                          height: 1.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
