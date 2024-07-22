import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final Map<String, dynamic> snap;

  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(snap['profilePic']),
            radius: 18,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snap['username'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(snap['comment']),
            ],
          ),
        ],
      ),
    );
  }
}




// import 'package:flutter/material.dart';

// class CommentCard extends StatelessWidget {
//   final Map<String, dynamic> snap;

//   const CommentCard({Key? key, required this.snap}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundImage: NetworkImage(snap['profilePic']),
//             radius: 18,
//           ),
//           const SizedBox(width: 8),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 snap['username'],
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(snap['comment']),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class CommentCards extends StatefulWidget {
//   final snap;
//   const CommentCards({super.key, required this.snap});

//   @override
//   State<CommentCards> createState() => _CommentCardsState();
// }

// class _CommentCardsState extends State<CommentCards> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundImage: NetworkImage(widget.snap['profimage']),
//             radius: 18,
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: widget.snap['name'],
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         TextSpan(
//                           text: " ${widget.snap['text']}",
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4),
//                     child: Text(
//                       DateFormat.yMMMd()
//                           .format(widget.snap['datePublished'].toDate()),
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(8),
//             child: const Icon(
//               Icons.favorite,
//               size: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
