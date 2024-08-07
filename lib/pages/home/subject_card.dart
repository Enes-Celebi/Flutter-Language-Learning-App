import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingoneer_beta_0_0_1/pages/home/subject_card_component.dart';

class SubjectCard extends StatefulWidget {
  final List<QueryDocumentSnapshot> subjectsSnapshot;
  final List<String> doneMapcardsIds;
  final PageController pageController;
  final AnimationController animationController;
  final Animation<Offset> slideAnimation;
  final Function(int) onPageChanged;
  final bool isInteractionDisabled;
  final int currentPage;
  final Function(String) goToSubjectLevel;
  final Function toggleArrow;
  final Color Function(String) getSubjectColor;

  const SubjectCard({
    super.key,
    required this.subjectsSnapshot,
    required this.doneMapcardsIds,
    required this.pageController,
    required this.animationController,
    required this.slideAnimation,
    required this.onPageChanged,
    required this.isInteractionDisabled,
    required this.currentPage,
    required this.goToSubjectLevel,
    required this.toggleArrow,
    required this.getSubjectColor,
  });

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.pageController,
      onPageChanged: widget.onPageChanged,
      physics: widget.isInteractionDisabled
          ? const NeverScrollableScrollPhysics()
          : const PageScrollPhysics(),
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

        return AnimatedBuilder(
          animation: widget.animationController,
          builder: (context, child) {
            final slideOffset = widget.slideAnimation.value;
            return Transform.translate(
              offset: slideOffset * MediaQuery.of(context).size.width,
              child: GestureDetector(
                onTap: () {
                  if (widget.isInteractionDisabled) {
                    widget.toggleArrow();
                  } else {
                    widget.goToSubjectLevel(subjectId);
                  }
                },
                child: child,
              ),
            );
          },
          child: MyMainCard(
            title: title ?? 'No Title',
            imagePath: imageURL ?? 'lib/assets/images/test/pic1.png',
            progressValue: progressValue,
            cardColor: cardColor,
            progressColor: cardColor.withOpacity(0.7),
            onTap: widget.isInteractionDisabled
                ? () {
                    widget.toggleArrow();
                  }
                : () {
                    widget.goToSubjectLevel(subjectId);
                  },
          ),
        );
      },
    );
  }
}
