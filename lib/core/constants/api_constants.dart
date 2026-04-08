class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://nripendra.online/api/v1';

  // Auth
  static const String login         = '/auth/login';
  static const String register      = '/auth/register';
  static const String socialLogin   = '/auth/social-login';

  // Exams
  static const String exams         = '/exams';
  static const String examPath      = '/exam-path';

  // Courses
  static const String courses       = '/courses';
  static const String playlists     = '/playlists';

  // Blog
  static const String blogs         = '/blogs';

  // Sarkari
  static const String sarkariJobs   = '/sarkari/jobs';
  static const String sarkariResult = '/sarkari/results';
  static const String admitCards    = '/sarkari/admit-cards';
  static const String answerKeys    = '/sarkari/answer-keys';

  // Test series
  static const String tests         = '/tests';
  static const String submitTest    = '/tests/submit';

  // Dashboard
  static const String userProgress  = '/user/progress';
  static const String streak        = '/user/streak';

  // Rank predictor
  static const String rankPredictor = '/rank-predictor';
  static const String cutoffData    = '/cutoff';
}