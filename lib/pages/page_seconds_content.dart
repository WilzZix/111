import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../utils/loyout.dart';

class PageSecondsContent extends StatefulWidget {
  final Map<String, dynamic> users;
  PageSecondsContent({Key? key, required this.users}) : super(key: key);

  @override
  State<PageSecondsContent> createState() => _PageSecondsContentState();
}

class _PageSecondsContentState extends State<PageSecondsContent> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = AppLayout.getSize(context);
    return media.size.width < 440
        ? Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppLayout.getHeight(22),
                vertical: AppLayout.getHeight(8)),
            width: size.width * 0.9,
            height: AppLayout.getHeight(45),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppLayout.getHeight(10)),
              color: Colors.grey[100],
              border: Border.all(
                color: Colors.blue.shade100,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('ФИО: ',
                        style: TextStyle(
                            fontSize: AppLayout.getHeight(15),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade700)),
                  ],
                ),
                Gap(AppLayout.getHeight(5)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.users['lastName']}',
                      style: TextStyle(
                          fontSize: AppLayout.getHeight(17),
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade900),
                    ),
                  ],
                ),
                Gap(AppLayout.getHeight(5)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.users['firstName']}',
                      style: TextStyle(
                          fontSize: AppLayout.getHeight(17),
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade900),
                    ),
                  ],
                ),
                Gap(AppLayout.getHeight(5)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.users['middleName']}',
                      style: TextStyle(
                          fontSize: AppLayout.getHeight(17),
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade900),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppLayout.getHeight(22),
                vertical: AppLayout.getHeight(8)),
            width: size.width * 0.8,
            height: AppLayout.getHeight(65),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppLayout.getHeight(10)),
              color: Colors.grey[100],
              border: Border.all(
                color: Colors.blue.shade100,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(AppLayout.getHeight(5)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Имя: ',
                      style: TextStyle(
                          fontSize: AppLayout.getHeight(15),
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade700),
                    ),
                    Gap(AppLayout.getHeight(5)),
                    Text(
                      '${widget.users['firstName']}',
                      style: TextStyle(
                          fontSize: AppLayout.getHeight(17),
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade900),
                    ),
                  ],
                ),
                Gap(AppLayout.getHeight(5)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Фамилия: ',
                      style: TextStyle(
                          fontSize: AppLayout.getHeight(15),
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade700),
                    ),
                    Gap(AppLayout.getHeight(5)),
                    Text(
                      '${widget.users['lastName']}',
                      style: TextStyle(
                          fontSize: AppLayout.getHeight(17),
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade900),
                    ),
                  ],
                ),
                Gap(AppLayout.getHeight(5)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Отчество: ',
                      style: TextStyle(
                          fontSize: AppLayout.getHeight(15),
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade700),
                    ),
                    Gap(AppLayout.getHeight(5)),
                    Text(
                      '${widget.users['middleName']}',
                      style: TextStyle(
                          fontSize: AppLayout.getHeight(17),
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade900),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
