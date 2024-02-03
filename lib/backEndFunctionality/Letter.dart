import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class Attachment {
  final String name;
  final Uint8List content;

  Attachment({
    required this.name,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'content': base64Encode(content),
    };
  }

  static Attachment fromMap(Map<String, dynamic> map) {
    return Attachment(
      name: map['name'] as String,
      content: base64Decode(map['content'] as String),
    );
  }
}

class Letter {
  final String referenceNumber;
  final DateTime date;
  final String senderName;
  final String organization;
  final String subject;
  final String urgency;
  final String contentSummary;
  final Attachment attachments;
  final String assignedTo;
  final String createdBy;
  final String comments;

  Letter({
    required this.referenceNumber,
    required this.date,
    required this.senderName,
    required this.organization,
    required this.subject,
    required this.urgency,
    required this.contentSummary,
    required this.attachments,
    // required this.attachmentName,
    // required this.attachmentPath,
    // this.attachmentBuffer,
    required this.assignedTo,
    required this.createdBy,
    required this.comments,
  });

  factory Letter.fromMap(Map<String, dynamic> map) {
    return Letter(
      referenceNumber: map['referenceNumber'] as String,
      date: DateTime.parse(map['date'] as String),
      senderName: map['senderName'] as String,
      organization: map['organization'] as String,
      subject: map['subject'] as String,
      urgency: map['urgency'] as String,
      contentSummary: map['contentSummary'] as String,
      //attachments: _decodeAttachment(map['attachments'] as String),
      attachments: Attachment.fromMap(map['attachments']),

      assignedTo: map['assignedTo'] as String,
      createdBy: map['createdBy'] as String,
      comments: map['comments'] as String,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'referenceNumber': referenceNumber,
      'date': date.toIso8601String(),
      'senderName': senderName,
      'organization': organization,
      'subject': subject,
      'urgency': urgency,
      'contentSummary': contentSummary,
      //'attachments': _encodeAttachment(attachments),
      'attachments': attachments.toMap(),
      'assignedTo': assignedTo,
      'createdBy': createdBy,
      'comments': comments,
    };
  }
  static Uint8List _decodeAttachment(String base64String) {
    return base64Decode(base64String);
  }

  static String _encodeAttachment(Uint8List data) {
    return base64Encode(data);
  }
}
