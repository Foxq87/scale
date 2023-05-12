List<Question> questions = [
  Question(
    paragraph: '',
    imageUrl: '',
    lesson: 0,
    unit: 0,
    title: "Aşağıdaki öğelerden hangisi bir edebi eser içerisinde bulunmaz?",
    choices: ["Roman", "Hikaye", "Şiir", "Dergi", "Oyun"],
    answer: 3,
    shownTo: [],
  ),
  Question(
    paragraph: '',
    imageUrl: '',
    lesson: 0,
    unit: 0,
    title: "Edebiyatın dilinin sade olması neden önemlidir?",
    choices: [
      "Dilin sade olması okuyucunun anlaması kolaylaştırır",
      "Dilin sade olması yazarın edebi yeteneğinin göstergesidir",
      "Dilin sade olması edebi eserin kalitesini düşürür",
      "Dilin sade olması yalnızca halk edebiyatında önemlidir",
      "Dilin sade olması modern edebiyatın gerekliliğidir",
    ],
    answer: 0,
    shownTo: [],
  ),
  Question(
    paragraph: '',
    imageUrl: '',
    lesson: 0,
    unit: 0,
    title: "Şiirde kullanılan ölçü ve uyak unsurları neden önemlidir?",
    choices: [
      "Şiirin ritmik yapısını sağlar",
      "Şiirin anlamını belirler",
      "Şiirin okunmasını kolaylaştırır",
      "Şiirin uyumlu ve bütüncül bir bütünlük oluşturmasını sağlar",
      "Şiirin tarzını belirler",
    ],
    answer: 3,
    shownTo: [],
  ),
  Question(
    paragraph: '',
    imageUrl: '',
    lesson: 0,
    unit: 0,
    title: "Aşağıdaki dönemlerden hangisi Türk edebiyatı tarihinde yer almaz?",
    choices: [
      "Divan Edebiyatı",
      "Tanzimat Edebiyatı",
      "Yeni Edebiyat",
      "Osmanlı Edebiyatı",
      "Milli Edebiyat"
    ],
    answer: 3,
    shownTo: [],
  ),
  Question(
    title: "Edebiyatımızda ilk yazılı eser hangisidir?",
    choices: [
      "Dede Korkut Hikayeleri",
      "Divan-ı Hikmet",
      "Kutadgu Bilig",
      "Kökenli Türkçe Sözlük",
      "Divan-ı Lügat-ı Türk"
    ],
    answer: 4,
    unit: 0,
    lesson: 0,
    paragraph: "",
    imageUrl: "",
    shownTo: [],
  ),
];

class Question {
  final int lesson;
  final int unit;
  final String title;
  final String imageUrl;
  final String paragraph;
  final int answer;
  final List<String> choices;
  final List<String> shownTo;

  Question({
    required this.lesson,
    required this.unit,
    required this.paragraph,
    required this.choices,
    required this.shownTo,
    required this.title,
    required this.imageUrl,
    required this.answer,
  });
}
