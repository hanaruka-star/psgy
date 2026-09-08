import 'package:psgy/features/pilot_demo/models/mock_coach.dart';
import 'package:psgy/features/pilot_demo/models/mock_package.dart';
import 'package:psgy/features/pilot_demo/models/mock_service.dart';

const _p1 = 'assets/images/journal/seed_01.jpg';
const _p2 = 'assets/images/journal/seed_02.jpg';
const _p3 = 'assets/images/journal/seed_03.jpg';
const _p4 = 'assets/images/journal/seed_04.jpg';

const _personal60 = MockService(
  id: 'svc_personal_60',
  name: 'Tập cá nhân 60 phút',
  priceVnd: 300000,
  durationMinutes: 60,
);

const _duo60 = MockService(
  id: 'svc_duo_60',
  name: 'Tập cặp đôi 60 phút',
  priceVnd: 500000,
  durationMinutes: 60,
);

const _nutrition = MockService(
  id: 'svc_nutrition',
  name: 'Tư vấn dinh dưỡng',
  priceVnd: 150000,
  durationMinutes: 45,
);

const _personal90 = MockService(
  id: 'svc_personal_90',
  name: 'Tập cá nhân 90 phút',
  priceVnd: 420000,
  durationMinutes: 90,
);

const _pkgLong10 = MockPackage(
  id: 'pkg_long_10',
  coachId: 'coach_01',
  name: 'Gói 10 buổi',
  sessionCount: 10,
  totalPriceVnd: 2500000,
  description: 'Linh hoạt lịch trong 3 tháng, tiết kiệm so với tập lẻ.',
);

const _pkgLong20 = MockPackage(
  id: 'pkg_long_20',
  coachId: 'coach_01',
  name: 'Gói 20 buổi',
  sessionCount: 20,
  totalPriceVnd: 4500000,
  description: 'Ưu đãi dài hạn, kèm 1 buổi tư vấn dinh dưỡng.',
);

const _policyDefault =
    'Huỷ miễn phí trước 2 giờ. Huỷ trễ hơn tính 50% giá dịch vụ.';

const List<MockCoach> mockCoaches = [
  MockCoach(
    id: 'coach_01',
    name: 'Nguyễn Văn Long',
    initials: 'NL',
    rating: 4.8,
    yearsExperience: 8,
    distanceKm: 0.8,
    nextSlotLabel: 'Rảnh 18:00 hôm nay',
    lat: 10.7765,
    lng: 106.7009,
    services: [_personal60, _duo60, _nutrition],
    packages: [_pkgLong10, _pkgLong20],
    photoUrls: [_p1, _p2, _p3, _p4, _p1],
    totalBookings: 214,
    goals: ['Tăng cơ', 'Giảm mỡ', 'Tăng sức bền'],
    targetAudience: ['Nam', 'Người mới bắt đầu', 'VĐV'],
    trainingFormats: ['1-1', 'Nhóm 1-2'],
    gymFeeIncluded: true,
    trainingLocationAddress:
        'California Fitness, 209 Nguyễn Văn Linh, Q.7, TP.HCM',
    membershipFeeLabel: null,
    studentResults: [
      'Giảm 8kg trong 3 tháng cho học viên A, giữ cơ, không mệt vì cắt calo quá đà.',
      'Tăng 5kg cơ nạc sau 4 tháng cho học viên B, squat 1.5x trọng lượng cơ thể.',
      'Học viên C hết đau lưng khi ngồi văn phòng sau 8 tuần chỉnh form + mobility.',
    ],
    certifications: ['ACE Personal Trainer', 'Chứng chỉ dinh dưỡng thể thao'],
    bookingCancellationPolicy: _policyDefault,
    bio:
        'Mình là HLV thể hình với 8 năm đứng sàn, từng làm việc tại California Fitness và đồng hành cùng hơn 200 học viên — từ người mới chưa biết cầm tạ tới người chuẩn bị lên sân thi. Cách kèm thiên về kỹ thuật và kỷ luật vừa phải: mỗi buổi có mục tiêu rõ, chỉnh form trước khi tăng tạ, luôn chừa 5–7 phút hỏi đáp cuối buổi. Giáo án xoay quanh tăng cơ, giảm mỡ và giữ thói quen ăn uống bền, không ép thực đơn cực đoan rồi bỏ cuộc sau 3 tuần. Học viên văn phòng thường 3 buổi/tuần; ai muốn thay đổi dáng nhanh hơn có thể lên 4–5 buổi. Mình có chứng chỉ ACE Personal Trainer, từng dẫn team thi Fitness Model quốc gia, và vẫn học thêm về phục hồi để học viên tập được lâu chứ không chỉ “căng” trong một tháng rồi mất form.',
  ),
  MockCoach(
    id: 'coach_02',
    name: 'Trần Thị Mai',
    initials: 'TM',
    rating: 4.9,
    yearsExperience: 10,
    distanceKm: 1.5,
    nextSlotLabel: 'Rảnh 19:30 hôm nay',
    lat: 10.7798,
    lng: 106.6882,
    services: [_personal60, _nutrition],
    packages: [
      MockPackage(
        id: 'pkg_mai_5',
        coachId: 'coach_02',
        name: 'Gói 5 buổi',
        sessionCount: 5,
        totalPriceVnd: 1400000,
        description: 'Phù hợp dinh dưỡng + tập cá nhân.',
      ),
    ],
    photoUrls: [_p2, _p3, _p4, _p1, _p2],
    totalBookings: 186,
    goals: ['Giảm mỡ', 'Phục hồi sau chấn thương', 'Tăng sức bền'],
    targetAudience: ['Nữ', 'Người mới bắt đầu', 'Phục hồi chấn thương'],
    trainingFormats: ['1-1', 'Online'],
    gymFeeIncluded: false,
    trainingLocationAddress:
        'Citigym Pasteur, 42 Nguyễn Thị Minh Khai, Q.1, TP.HCM',
    membershipFeeLabel: 'Membership phòng 650.000đ/tháng (học viên tự lo)',
    studentResults: [
      'Học viên D giảm 6kg trong 10 tuần, vòng eo -8cm, vẫn ăn cơm nhà.',
      'Học viên E (văn phòng) hết đau cổ vai sau 6 tuần kết hợp tập + chỉnh chỗ ngồi.',
    ],
    certifications: [
      'NASM Certified Personal Trainer',
      'Chứng chỉ dinh dưỡng thể thao',
      'Precision Nutrition L1',
    ],
    bookingCancellationPolicy:
        'Huỷ miễn phí trước 3 giờ. Huỷ sát giờ hoặc không đến tính 50% buổi.',
    bio:
        'Mười năm kèm dinh dưỡng đi cùng tập cá nhân đã dạy mình một điều: giáo án đẹp trên giấy chẳng nghĩa lý gì nếu học viên không sống nổi với nó suốt tuần. Mình ưu tiên lịch văn phòng — buổi tối, cường độ vừa, bài ít máy phức tạp — và luôn neo thực đơn vào món quen: cơm, rau, đạm, không bắt đổi sang meal-prep tiếng Anh. Với người mới, 2–3 tuần đầu chỉ xây thói quen đến phòng và ngủ đủ; giảm mỡ tính sau. Với người đang phục hồi chấn thương, mình phối hợp với hướng dẫn của bác sĩ/physio, không tự ý “kéo” bài nặng. Có thể kèm online khi đi công tác. Mục tiêu của mình không phải biến bạn thành VĐV, mà để bạn nhìn thấy số trên cân và cảm giác trên người đi đúng hướng mà không sợ ăn uống.',
  ),
  MockCoach(
    id: 'coach_03',
    name: 'Lê Hoàng Nam',
    initials: 'LN',
    rating: 4.6,
    yearsExperience: 6,
    distanceKm: 2.1,
    nextSlotLabel: 'Rảnh 17:00 hôm nay',
    lat: 10.8104,
    lng: 106.7098,
    services: [_personal60, _duo60],
    packages: [
      MockPackage(
        id: 'pkg_nam_10',
        coachId: 'coach_03',
        name: 'Gói 10 buổi',
        sessionCount: 10,
        totalPriceVnd: 2700000,
        description: 'Tập cá nhân hoặc cặp đôi.',
      ),
    ],
    photoUrls: [_p3, _p4, _p1, _p2, _p3],
    totalBookings: 97,
    goals: ['Tăng cơ', 'Tăng sức bền'],
    targetAudience: ['Nam', 'Nữ', 'VĐV'],
    trainingFormats: ['1-1', 'Nhóm 1-2'],
    gymFeeIncluded: true,
    trainingLocationAddress:
        'GetFit Gym, 18 Phan Xích Long, Phú Nhuận, TP.HCM',
    membershipFeeLabel: null,
    studentResults: [
      'Cặp vợ chồng F tăng sức bền chạy 5km từ 38 phút xuống 29 phút sau 3 tháng.',
      'Học viên G deadlift từ 80kg lên 140kg trong 5 tháng, không đau lưng.',
    ],
    certifications: ['CSCS', 'CrossFit L1'],
    bookingCancellationPolicy: _policyDefault,
    bio:
        'Sáu năm strength training, phần lớn thời gian mình đứng với các cặp đôi và nhóm nhỏ cuối tuần hơn là buổi 1-1 kín mít. Mình thích bài compound: squat, hinge, push, pull — lập lại đủ lần cho não và cơ nhớ, rồi mới nghĩ tới isolation. Nhịp buổi nhanh, nhạc vừa, không la ó nhưng cũng không để học viên đứng chơi điện thoại giữa set. Nếu tập cặp, mình chia load theo người yếu hơn rồi chồng bài phụ cho người khoẻ hơn, tránh một người “kéo” cả buổi. VĐV nghiệp dư (chạy, bơi, võ) đến với mình khi cần nền sức mạnh, không phải giáo án thi đấu chuyên. Phòng mình dùng có sẵn rack và sàn cao su; phí phòng đã gói trong giá buổi nên bạn không phải mua membership riêng.',
  ),
  MockCoach(
    id: 'coach_04',
    name: 'Phạm Minh Châu',
    initials: 'PC',
    rating: 4.7,
    yearsExperience: 7,
    distanceKm: 3.4,
    nextSlotLabel: 'Rảnh 07:00 ngày mai',
    lat: 10.7872,
    lng: 106.7185,
    services: [_personal90, _nutrition, _duo60],
    packages: [
      MockPackage(
        id: 'pkg_chau_8',
        coachId: 'coach_04',
        name: 'Gói 8 buổi',
        sessionCount: 8,
        totalPriceVnd: 2200000,
        description: 'Buổi sáng, kèm tư vấn dinh dưỡng.',
      ),
    ],
    photoUrls: [_p4, _p1, _p2, _p3, _p4],
    totalBookings: 142,
    goals: ['Giảm mỡ', 'Tăng sức bền', 'Phục hồi sau chấn thương'],
    targetAudience: ['Nữ', 'Nam', 'Người mới bắt đầu'],
    trainingFormats: ['1-1', 'Online', 'Nhóm 1-2'],
    gymFeeIncluded: false,
    trainingLocationAddress:
        'California Fitness, 72 Lê Thánh Tôn, Q.1, TP.HCM',
    membershipFeeLabel: 'Membership phòng 790.000đ/tháng (học viên tự lo)',
    studentResults: [
      'Học viên H giảm 9kg sau 4 tháng buổi sáng 90 phút, xét nghiệm mỡ máu cải thiện.',
      'Học viên I (sau mổ gối) trở lại chạy bộ nhẹ 3km sau 12 tuần theo phác đồ bác sĩ.',
      'Học viên K bỏ được thói quen bỏ bữa sáng, năng lượng làm việc ổn định hơn.',
    ],
    certifications: [
      'ACE Personal Trainer',
      'Chứng chỉ dinh dưỡng thể thao',
    ],
    bookingCancellationPolicy:
        'Huỷ miễn phí trước 2 giờ. Buổi 07:00 huỷ sau 21:00 hôm trước tính 50%.',
    bio:
        'Mình là HLV buổi sáng: 07:00–09:00 là khung mình tỉnh nhất và học viên cũng ít bị họp cắt ngang. Buổi 90 phút cho phép khởi động kỹ, tập chính, rồi còn thời gian nói chuyện ăn uống — không phải nhồi dinh dưỡng vào 60 phút đã hết hơi. Bảy năm làm việc với người đi làm sớm, mẹ bỉm muốn lấy lại form, và người mới sợ phòng gym đông. Giáo án thiên về nhịp thở, core, và bài không cần ego-lifting. Phòng tập tại Q.1, học viên tự lo membership; mình không cộng phí phòng vào giá buổi để bạn so sánh rõ. Nếu đang phục hồi chấn thương, hãy mang giấy của bác sĩ/physio — mình không thay thế điều trị, chỉ xây sức quanh phần được phép tập.',
  ),
  MockCoach(
    id: 'coach_05',
    name: 'Võ Thành Đạt',
    initials: 'VĐ',
    rating: 4.2,
    yearsExperience: 4,
    distanceKm: 4.2,
    nextSlotLabel: 'Rảnh 20:00 hôm nay',
    lat: 10.7721,
    lng: 106.7210,
    services: [_personal60, _duo60],
    packages: [],
    photoUrls: [_p1, _p3, _p2, _p4, _p1],
    totalBookings: 48,
    goals: ['Tăng cơ', 'Tăng sức bền'],
    targetAudience: ['Nam', 'Người mới bắt đầu'],
    trainingFormats: ['1-1', 'Nhóm 1-2'],
    gymFeeIncluded: true,
    trainingLocationAddress:
        'Anytime Fitness, 15 Điện Biên Phủ, Bình Thạnh, TP.HCM',
    membershipFeeLabel: null,
    studentResults: [
      'Học viên L (chưa từng tập) squat đúng form với 40kg sau 8 tuần.',
      'Học viên M hết né phòng gym giờ cao điểm, tập đều 3 buổi/tuần suốt 2 tháng.',
    ],
    certifications: ['Chứng chỉ HLV thể hình cơ bản'],
    bookingCancellationPolicy: _policyDefault,
    bio:
        'Bốn năm kèm người mới là khoảng thời gian mình học cách nói chậm lại. Học viên tới với mình thường là nam mới bắt đầu, hơi ngại máy, hay tập tối sau giờ làm. Buổi 60 phút nhịp vừa: không biến thành lớp bootcamp, cũng không để bạn đứng xem điện thoại. Mình giải thích “tạ này để làm gì” trước khi bảo bạn làm; form ổn rồi mới tăng. Chưa mở gói nhiều buổi vì mình muốn bạn thử 1-1 đã, thấy hợp rồi hẵng nói chuyện dài hạn. Phí phòng đã gồm trong giá. Nếu bạn từng bỏ gym giữa chừng, hãy nói thẳng — mình sẽ cắt bài cho vừa lịch thật, chứ không viết giáo án 6 buổi/tuần rồi cả hai cùng thất hứa.',
  ),
  MockCoach(
    id: 'coach_06',
    name: 'Hoàng Thị Thu Hà',
    initials: 'HH',
    rating: 4.5,
    yearsExperience: 12,
    distanceKm: 5.0,
    nextSlotLabel: 'Rảnh 09:00 ngày mai',
    lat: 10.8250,
    lng: 106.6952,
    services: [_personal60, _nutrition, _personal90],
    packages: [
      MockPackage(
        id: 'pkg_ha_12',
        coachId: 'coach_06',
        name: 'Gói 12 buổi',
        sessionCount: 12,
        totalPriceVnd: 3200000,
        description: 'Lịch sáng, tập cá nhân 60 hoặc 90 phút.',
      ),
    ],
    photoUrls: [_p2, _p4, _p1, _p3, _p2],
    totalBookings: 268,
    goals: ['Giảm mỡ', 'Tăng cơ', 'Phục hồi sau chấn thương'],
    targetAudience: ['Nữ', 'Nam', 'Phục hồi chấn thương', 'Người mới bắt đầu'],
    trainingFormats: ['1-1', 'Online'],
    gymFeeIncluded: false,
    trainingLocationAddress:
        'Elite Fitness, 2 Hải Triều, Q.1, TP.HCM',
    membershipFeeLabel: 'Membership phòng 1.200.000đ/tháng (học viên tự lo)',
    studentResults: [
      'Học viên N giảm 8kg trong 3 tháng, đo InBody mỡ -4.2%.',
      'Học viên O tăng 4kg cơ sau 5 tháng, giữ được khi đi công tác nhờ buổi online.',
      'Học viên P (thoái hoá gối nhẹ) tập được 90 phút không sưng sau 10 tuần.',
    ],
    certifications: [
      'ACE Personal Trainer',
      'NASM CES',
      'Chứng chỉ dinh dưỡng thể thao',
    ],
    bookingCancellationPolicy:
        'Huỷ miễn phí trước 4 giờ. Đổi lịch trong cùng ngày nếu còn slot trống.',
    bio:
        'Mười hai năm HLV buổi sáng dài đã cho mình một lớp học viên quen: người muốn khoẻ thật, không cần lên ảnh quá đà. Giáo án cá nhân 60 hoặc 90 phút, luôn kèm phần dinh dưỡng ngắn — không phải vì “bán thêm”, mà vì buổi tập đẹp sẽ phí nếu tối về lại bỏ bữa. Mình nhận cả người mới và người đang phục hồi; với chấn thương, ranh giới rất rõ: mình không chữa, chỉ tập phần được phép. Có buổi online khi bạn đi vắng. Phòng Elite Fitness Q.1 yêu cầu membership riêng, mình ghi rõ trên hồ sơ để không bất ngờ lúc thanh toán. Nếu bạn tìm HLV la ó và đếm calories từng hạt cơm, mình không phải người đó. Nếu bạn cần ai đó già hơn một chút, nói thẳng, và giữ bạn tới phòng lúc 09:00, thì nhắn lịch.',
  ),
];
