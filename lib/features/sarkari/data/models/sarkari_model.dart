import '../../domain/entities/sarkari_entity.dart';

class SarkariModel extends SarkariEntity {
  const SarkariModel({
    required super.id,
    required super.type,
    required super.examName,
    required super.organization,
    required super.title,
    super.description,
    super.totalPosts,
    super.lastDate,
    super.examDate,
    super.officialLink,
    super.applyLink,
    required super.status,
    required super.postedAt,
  });

  factory SarkariModel.fromJson(Map<String, dynamic> j) => SarkariModel(
    id:           j['_id']          as String,
    examName:     j['examName']     as String,
    organization: j['organization'] as String,
    title:        j['title']        as String,
    description:  j['description']  as String?,
    totalPosts:   j['totalPosts']   as int?,
    officialLink: j['officialLink'] as String?,
    applyLink:    j['applyLink']    as String?,
    lastDate:     j['lastDate']  != null
        ? DateTime.tryParse(j['lastDate'] as String)
        : null,
    examDate:     j['examDate']  != null
        ? DateTime.tryParse(j['examDate'] as String)
        : null,
    postedAt:     DateTime.tryParse(j['postedAt'] as String? ?? '') ??
        DateTime.now(),
    type:   _parseType(j['type']     as String? ?? 'job'),
    status: _parseStatus(j['status'] as String? ?? 'active'),
  );

  static SarkariType _parseType(String s) {
    switch (s) {
      case 'result':      return SarkariType.result;
      case 'admit_card':  return SarkariType.admitCard;
      case 'answer_key':  return SarkariType.answerKey;
      default:            return SarkariType.job;
    }
  }

  static SarkariStatus _parseStatus(String s) {
    switch (s) {
      case 'closed':   return SarkariStatus.closed;
      case 'upcoming': return SarkariStatus.upcoming;
      default:         return SarkariStatus.active;
    }
  }

  Map<String, dynamic> toJson() => {
    '_id':          id,
    'type':         _typeToString(type),
    'examName':     examName,
    'organization': organization,
    'title':        title,
    'description':  description,
    'totalPosts':   totalPosts,
    'officialLink': officialLink,
    'applyLink':    applyLink,
    'lastDate':     lastDate?.toIso8601String(),
    'examDate':     examDate?.toIso8601String(),
    'postedAt':     postedAt.toIso8601String(),
    'status':       _statusToString(status),
  };

  static String _typeToString(SarkariType t) {
    switch (t) {
      case SarkariType.result:    return 'result';
      case SarkariType.admitCard: return 'admit_card';
      case SarkariType.answerKey: return 'answer_key';
      default:                    return 'job';
    }
  }

  static String _statusToString(SarkariStatus s) {
    switch (s) {
      case SarkariStatus.closed:   return 'closed';
      case SarkariStatus.upcoming: return 'upcoming';
      default:                     return 'active';
    }
  }
}