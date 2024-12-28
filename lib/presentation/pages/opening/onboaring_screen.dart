import 'package:flutter/material.dart';
import 'package:sep490/domain/use_cases/user_pref_repository.dart';
import 'package:sep490/presentation/pages/opening/select_sign.dart';
import 'package:sep490/presentation/pages/opening/welcome_screen.dart';
import 'package:sep490/presentation/widgets/on_boarding_slide_data.dart';
import 'package:sep490/theme/color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoaringScreen extends StatefulWidget {
  final CheckUserOnboardingUseCase userOnboardingUseCase;
  const OnBoaringScreen({super.key, required this.userOnboardingUseCase});

  @override
  State<OnBoaringScreen> createState() => _OnBoaringScreenState();
}

class _OnBoaringScreenState extends State<OnBoaringScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<OnBoardingSlideData> slides = [
    const OnBoardingSlideData(
      imagePath: 'assets/img/onBoard1.png',
      title: 'Kết nối với những người thân yêu',
      description:
          'Dễ dàng trò chuyện và gọi video cho các thành viên trong gia đình, chia sẻ những khoảnh khắc đặc biệt cho nhau.',
    ),
    const OnBoardingSlideData(
      imagePath: 'assets/img/onBoard2.png',
      title: 'Quản lý sức khỏe của bạn một cách dễ dàng',
      description:
          'Theo dõi các chỉ số sức khỏe quan trọng, nhận lời nhắc uống thuốc và truy cập hỗ trợ khẩn cấp—tất cả tại một nơi.',
    ),
    const OnBoardingSlideData(
      imagePath: 'assets/img/onBoard3.png',
      title: 'Thưởng thức các hoạt động hấp dẫn',
      description:
          'Truy cập video, tài liệu đọc, trò chơi nhẹ nhàng và các bài tập hỗ trợ thể chất để giúp bạn năng động và giải trí mỗi ngày.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await widget.userOnboardingUseCase.completeOnboarding();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const SelectSignScreen(),
      ),
    );
  }

  void _goToNextPage() {
    if (_currentPage < slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WelcomeScreen(
            userOnboardingUseCase: widget.userOnboardingUseCase,
          ),
        ),
      );
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _skipOnboarding,
            child: Row(
              children: const [
                Text(
                  'Bỏ qua',
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.secondaryColor,
                  size: 18,
                ),
              ],
            )
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: slides.length,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        itemBuilder: (context, index) {
          return OnBoardingSlide(slide: slides[index]);
        },
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: AppColors.bgColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SmoothPageIndicator(
              controller: _pageController,
              count: slides.length,
              effect: WormEffect(
                activeDotColor: AppColors.secondaryColor,
                dotColor: AppColors.secondaryColor.withOpacity(0.5),
                dotHeight: 12,
                dotWidth: 12,
                spacing: 6,
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 20),
                  child: ElevatedButton(
                    onPressed: _goToPreviousPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.grayColor1,
                      minimumSize: const Size(0, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.secondaryColor,
                      size: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: ElevatedButton(
                      onPressed: _goToNextPage,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      child: Text(
                          _currentPage == slides.length - 1
                              ? 'Hoàn tất'
                              : 'Tiếp tục',
                          style: TextStyle(
                            fontSize: 28,
                            color: AppColors.bgColor,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
