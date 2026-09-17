import 'package:psgy/features/pilot_demo/models/mock_ai_cue.dart';
import 'package:psgy/features/pilot_demo/models/mock_ai_exercise.dart';

const _thumb1 = 'assets/images/journal/seed_01.jpg';
const _thumb2 = 'assets/images/journal/seed_02.jpg';
const _thumb3 = 'assets/images/journal/seed_03.jpg';
const _thumb4 = 'assets/images/journal/seed_04.jpg';

/// DEMO DATA — 6 bài tập căn bản + kịch bản AI theo timer, không phải pose detection.
const List<MockAiExercise> mockAiExercises = [
  MockAiExercise(
    id: 'ai_squat',
    name: 'Squat',
    description: 'Tập đùi và mông, đứng rộng bằng vai, hạ thấp như ngồi ghế.',
    durationSeconds: 45,
    thumbnailAsset: _thumb1,
    cues: [
      MockAiCue(atSecond: 0, message: 'Chuẩn bị... đứng rộng bằng vai'),
      MockAiCue(atSecond: 3, message: 'Bắt đầu! Hạ thấp từ từ'),
      MockAiCue(atSecond: 15, message: 'Tốt! Giữ lưng thẳng, đừng cong người'),
      MockAiCue(atSecond: 30, message: 'Còn 15 giây, cố lên!'),
      MockAiCue(atSecond: 42, message: 'Sắp xong, chậm lại và thở đều'),
    ],
  ),
  MockAiExercise(
    id: 'ai_plank',
    name: 'Plank',
    description: 'Giữ thẳng lưng, siết bụng, chống khuỷu tay và mũi chân.',
    durationSeconds: 30,
    thumbnailAsset: _thumb2,
    cues: [
      MockAiCue(atSecond: 0, message: 'Chuẩn bị... chống khuỷu và mũi chân'),
      MockAiCue(atSecond: 3, message: 'Bắt đầu! Siết bụng, lưng thẳng'),
      MockAiCue(atSecond: 12, message: 'Tốt! Đừng võng lưng'),
      MockAiCue(atSecond: 20, message: 'Còn 10 giây, thở đều'),
      MockAiCue(atSecond: 27, message: 'Sắp xong, giữ vững'),
    ],
  ),
  MockAiExercise(
    id: 'ai_lunge',
    name: 'Lunge (Chùng chân)',
    description: 'Bước dài về trước, hạ gối sau gần chạm sàn, đổi chân.',
    durationSeconds: 40,
    thumbnailAsset: _thumb3,
    cues: [
      MockAiCue(atSecond: 0, message: 'Chuẩn bị... đứng thẳng, hai chân rộng vừa'),
      MockAiCue(atSecond: 3, message: 'Bước dài về trước, hạ gối sau'),
      MockAiCue(atSecond: 15, message: 'Tốt! Gối trước không vượt mũi chân'),
      MockAiCue(atSecond: 28, message: 'Đổi chân, giữ nhịp đều'),
      MockAiCue(atSecond: 37, message: 'Sắp xong, đứng thẳng người'),
    ],
  ),
  MockAiExercise(
    id: 'ai_pushup',
    name: 'Hít đất (Push-up)',
    description: 'Chống thẳng tay, hạ ngực gần sàn, đẩy lên đều.',
    durationSeconds: 30,
    thumbnailAsset: _thumb4,
    cues: [
      MockAiCue(atSecond: 0, message: 'Chuẩn bị... chống thẳng tay'),
      MockAiCue(atSecond: 3, message: 'Hạ ngực gần sàn, đẩy lên đều'),
      MockAiCue(atSecond: 12, message: 'Tốt! Khuỷu sát người, đừng võng lưng'),
      MockAiCue(atSecond: 22, message: 'Còn 8 giây, giữ nhịp'),
      MockAiCue(atSecond: 27, message: 'Sắp xong, thở đều'),
    ],
  ),
  MockAiExercise(
    id: 'ai_crunch',
    name: 'Gập bụng (Crunch)',
    description: 'Nằm ngửa, gối co, nâng vai khỏi sàn, không kéo cổ.',
    durationSeconds: 40,
    thumbnailAsset: _thumb1,
    cues: [
      MockAiCue(atSecond: 0, message: 'Chuẩn bị... nằm ngửa, gối co'),
      MockAiCue(atSecond: 3, message: 'Nâng vai khỏi sàn, thở ra khi gập'),
      MockAiCue(atSecond: 15, message: 'Tốt! Đừng kéo cổ'),
      MockAiCue(atSecond: 28, message: 'Còn 12 giây, siết bụng'),
      MockAiCue(atSecond: 37, message: 'Sắp xong, hạ chậm'),
    ],
  ),
  MockAiExercise(
    id: 'ai_wallsit',
    name: 'Đứng tấn (Wall sit)',
    description: 'Lưng tựa tường, đùi song song sàn, giữ nguyên tư thế.',
    durationSeconds: 30,
    thumbnailAsset: _thumb2,
    cues: [
      MockAiCue(atSecond: 0, message: 'Chuẩn bị... lưng tựa tường'),
      MockAiCue(atSecond: 3, message: 'Hạ đùi song song sàn'),
      MockAiCue(atSecond: 12, message: 'Tốt! Giữ gối vuông góc'),
      MockAiCue(atSecond: 22, message: 'Còn 8 giây, đừng đứng dậy sớm'),
      MockAiCue(atSecond: 27, message: 'Sắp xong, thở đều'),
    ],
  ),
];
