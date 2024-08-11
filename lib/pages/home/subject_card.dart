import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Import the flutter_animate package
import 'package:lingoneer_beta_0_0_1/pages/home/subject_card_component.dart';

class SubjectCard extends StatefulWidget {
  final List<QueryDocumentSnapshot> subjectsSnapshot;
  final List<String> doneMapcardsIds;
  final PageController pageController;
  final Function(int) onPageChanged;
  final int currentPage;
  final Function(String) goToSubjectLevel;
  final Function toggleArrow;
  final Color Function(String) getSubjectColor;
  final bool isArrowDown;

  const SubjectCard({
    super.key,
    required this.subjectsSnapshot,
    required this.doneMapcardsIds,
    required this.pageController,
    required this.onPageChanged,
    required this.currentPage,
    required this.goToSubjectLevel,
    required this.toggleArrow,
    required this.getSubjectColor,
    required this.isArrowDown,
  });

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.isArrowDown ? const Offset(0.4, 0.0) : Offset.zero,
      end: widget.isArrowDown ? Offset.zero : const Offset(0.4, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(SubjectCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isArrowDown != widget.isArrowDown) {
      _slideAnimation = Tween<Offset>(
        begin: widget.isArrowDown ? const Offset(0.4, 0.0) : Offset.zero,
        end: widget.isArrowDown ? Offset.zero : const Offset(0.4, 0.0),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.pageController,
      onPageChanged: widget.onPageChanged,
      itemCount: widget.subjectsSnapshot.length,
      itemBuilder: (context, index) {
        final subject = widget.subjectsSnapshot[index];
        final title = subject.get('name') as String?;
        final imageURL = subject.get('image') as String?;
        final subjectId = subject.get('id') as String;

        final countOfSpecificSubject =
            widget.doneMapcardsIds.where((id) => id == subjectId).length;
        final cardColor = widget.getSubjectColor(subjectId);
        final progressValue = countOfSpecificSubject / 32;

        return SlideTransition(
          position: _slideAnimation,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // Set width dynamically
            child: MyMainCard(
              title: title ?? 'No Title',
              imagePath: imageURL ?? 'lib/assets/images/test/pic1.png',
              progressValue: progressValue,
              cardColor: cardColor,
              progressColor: cardColor.withOpacity(0.7),
              onTap: () {
                widget.goToSubjectLevel(subjectId);
              },
            ),
          ),
        );
      },
    );
  }
}
