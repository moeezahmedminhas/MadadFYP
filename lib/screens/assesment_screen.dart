import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:madad_final/screens/quiz.dart';
import 'package:madad_final/screens/result.dart';

class AssesmentScreen extends StatefulWidget {
  static const routeName = '/assesment-screen';
  const AssesmentScreen({super.key});
  @override
  State<AssesmentScreen> createState() => _AssesmentScreenState();
}

class _AssesmentScreenState extends State<AssesmentScreen> {
  static const Q = [
    {'text': 'Did not apply to me at all', 'score': 1},
    {'text': 'Applied to me to some degree, or some of the time', 'score': 2},
    {
      'text':
          'Applied to me to a considerable degree, or a good part of the time',
      'score': 3
    },
    {'text': 'Applied to me very much, or most of the time', 'score': 4},
  ];
  static const T = [
    {'text': 'Disagree strongly', 'score': 1},
    {'text': 'Disagree moderately', 'score': 2},
    {'text': 'Disagree a little', 'score': 3},
    {'text': 'Neither agree nor disagree', 'score': 4},
    {'text': 'Agree a little', 'score': 5},
    {'text': 'Agree moderately', 'score': 6},
    {'text': 'Agree strongly', 'score': 7},
  ];
  static const education = [
    {'text': 'Never Married', 'score': 1},
    {'text': 'Currently married', 'score': 2},
    {'text': 'University degree', 'score': 3},
    {'text': 'Graduate degree', 'score': 4},
  ];
  static const area = [
    {'text': 'Rural (country side)', 'score': 1},
    {'text': 'Suburban', 'score': 2},
    {'text': 'Urban (town, city)', 'score': 3},
  ];
  static const gender = [
    {'text': 'Male', 'score': 1},
    {'text': 'Female', 'score': 2},
    {'text': 'Other', 'score': 3},
  ];
  static const religon = [
    {'text': 'Agnostic', 'score': 1},
    {'text': 'Atheist', 'score': 2},
    {'text': 'Buddhist', 'score': 3},
    {'text': 'Christian (Catholic)', 'score': 4},
    {'text': 'Christian (Mormon)', 'score': 5},
    {'text': 'Christian (Protestant)', 'score': 6},
    {'text': 'Christian (Other)', 'score': 7},
    {'text': 'Hindu', 'score': 8},
    {'text': 'Jewish', 'score': 9},
    {'text': 'Muslim', 'score': 10},
    {'text': 'Sikh', 'score': 11},
    {'text': 'Other', 'score': 12},
  ];
  static const race = [
    {'text': 'Asian', 'score': 1},
    {'text': 'Arab', 'score': 2},
    {'text': 'Black', 'score': 3},
    {'text': 'Indigenous Australian', 'score': 4},
    {'text': 'Native American', 'score': 5},
    {'text': 'White', 'score': 6},
    {'text': 'Other', 'score': 7},
  ];
  static const maritalStatus = [
    {'text': 'Never Married', 'score': 1},
    {'text': 'Currently married', 'score': 2},
    {'text': 'Previously married', 'score': 3},
  ];

  static const familySize = [
    {'text': 'One', 'score': 1},
    {'text': 'Two', 'score': 2},
    {'text': 'Three', 'score': 3},
    {'text': 'Four', 'score': 4},
    {'text': 'Five', 'score': 5},
    {'text': 'Six', 'score': 6},
    {'text': 'Seven', 'score': 7},
    {'text': 'Eight', 'score': 8},
    {'text': 'Nine', 'score': 9},
    {'text': 'Ten', 'score': 10},
    {'text': 'Eleven', 'score': 11},
    {'text': 'Twelve', 'score': 12},
    {'text': 'Thirteen', 'score': 13},
  ];
  static const age = [
    {'text': 'Under 10', 'score': 1},
    {'text': 'Between 10 and 16', 'score': 2},
    {'text': 'Between 17 and 21', 'score': 3},
    {'text': 'Between 22 and 35', 'score': 4},
    {'text': 'Between 36 and 48', 'score': 5},
    {'text': 'Above 49', 'score': 6},
  ];

  static const _questions = [
    {
      'questionText': 'I found myself getting upset by quite trivial things.',
      'answers': Q,
    },
    {
      'questionText': 'I was aware of dryness of my mouth.',
      'answers': Q,
    },
    {
      'questionText':
          'I couldn\'t seem to experience any positive feeling at all.',
      'answers': Q,
    },
    {
      'questionText':
          'I experienced breathing difficulty (eg, excessively rapid breathing, breathlessness in the absence of physical exertion).',
      'answers': Q,
    },
    {
      'questionText': 'I just couldn\'t seem to get going.',
      'answers': Q,
    },
    {
      'questionText': 'I tended to over-react to situations.',
      'answers': Q,
    },
    {
      'questionText':
          'I had a feeling of shakiness (eg, legs going to give way).',
      'answers': Q,
    },
    {
      'questionText': 'I found it difficult to relax.',
      'answers': Q,
    },
    {
      'questionText':
          'I found myself in situations that made me so anxious I was most relieved when they ended.',
      'answers': Q,
    },
    {
      'questionText': 'Q10	I felt that I had nothing to look forward to.',
      'answers': Q,
    },
    {
      'questionText': 'Q11	I found myself getting upset rather easily.',
      'answers': Q,
    },
    {
      'questionText': 'Q12	I felt that I was using a lot of nervous energy.',
      'answers': Q,
    },
    {
      'questionText': 'Q13	I felt sad and depressed.',
      'answers': Q,
    },
    {
      'questionText':
          'Q14	I found myself getting impatient when I was delayed in any way (eg, elevators, traffic lights, being kept waiting).',
      'answers': Q,
    },
    {
      'questionText': 'Q15	I had a feeling of faintness.',
      'answers': Q,
    },
    {
      'questionText':
          'Q16	I felt that I had lost interest in just about everything.',
      'answers': Q,
    },
    {
      'questionText': 'Q17	I felt I wasn\'t worth much as a person.',
      'answers': Q,
    },
    {
      'questionText': 'Q18	I felt that I was rather touchy.',
      'answers': Q,
    },
    {
      'questionText':
          'Q19	I perspired noticeably (eg, hands sweaty) in the absence of high temperatures or physical exertion.',
      'answers': Q,
    },
    {
      'questionText': 'Q20	I felt scared without any good reason.',
      'answers': Q,
    },
    {
      'questionText': 'Q21	I felt that life wasn\'t worthwhile.',
      'answers': Q,
    },
    {
      'questionText': 'Q22	I found it hard to wind down.',
      'answers': Q,
    },
    {
      'questionText': 'Q23	I had difficulty in swallowing.',
      'answers': Q,
    },
    {
      'questionText':
          'Q24	I couldn\'t seem to get any enjoyment out of the things I did.',
      'answers': Q,
    },
    {
      'questionText':
          'Q25	I was aware of the action of my heart in the absence of physical exertion (eg, sense of heart rate increase, heart missing a beat).',
      'answers': Q,
    },
    {
      'questionText': 'Q26	I felt down-hearted and blue.',
      'answers': Q,
    },
    {
      'questionText': 'Q27	I found that I was very irritable.',
      'answers': Q,
    },
    {
      'questionText': 'Q28	I felt I was close to panic.',
      'answers': Q,
    },
    {
      'questionText':
          'Q29	I found it hard to calm down after something upset me.',
      'answers': Q,
    },
    {
      'questionText':
          'Q30	I feared that I would be &quot;thrown&quot; by some trivial but unfamiliar task.',
      'answers': Q,
    },
    {
      'questionText': 'Q31	I was unable to become enthusiastic about anything.',
      'answers': Q,
    },
    {
      'questionText':
          'Q32	I found it difficult to tolerate interruptions to what I was doing.',
      'answers': Q,
    },
    {
      'questionText': 'Q33	I was in a state of nervous tension.',
      'answers': Q,
    },
    {
      'questionText': 'Q34	I felt I was pretty worthless.',
      'answers': Q,
    },
    {
      'questionText':
          'Q35	I was intolerant of anything that kept me from getting on with what I was doing.',
      'answers': Q,
    },
    {
      'questionText': 'Q36	I felt terrified.',
      'answers': Q,
    },
    {
      'questionText':
          'Q37	I could see nothing in the future to be hopeful about.',
      'answers': Q,
    },
    {
      'questionText': 'Q38	I felt that life was meaningless.',
      'answers': Q,
    },
    {
      'questionText': 'Q39	I found myself getting agitated.',
      'answers': Q,
    },
    {
      'questionText':
          'Q40	I was worried about situations in which I might panic and make a fool of myself.',
      'answers': Q,
    },
    {
      'questionText': 'Q41	I experienced trembling (eg, in the hands).',
      'answers': Q,
    },
    {
      'questionText':
          'Q42	I found it difficult to work up the initiative to do things.',
      'answers': Q,
    },
    {
      'questionText': 'TIPI1	Extraverted, enthusiastic.',
      'answers': T,
    },
    {
      'questionText': 'TIPI2	Critical, quarrelsome.',
      'answers': T,
    },
    {
      'questionText': 'TIPI3	Dependable, self-disciplined.',
      'answers': T,
    },
    {
      'questionText': 'TIPI4	Anxious, easily upset.',
      'answers': T,
    },
    {
      'questionText': 'TIPI5	Open to new experiences, complex.',
      'answers': T,
    },
    {
      'questionText': 'TIPI6	Reserved, quiet.',
      'answers': T,
    },
    {
      'questionText': 'TIPI7	Sympathetic, warm.',
      'answers': T,
    },
    {
      'questionText': 'TIPI8	Disorganized, careless.',
      'answers': T,
    },
    {
      'questionText': 'TIPI9	Calm, emotionally stable.',
      'answers': T,
    },
    {
      'questionText': 'TIPI10	Conventional, uncreative.',
      'answers': T,
    },
    {
      'questionText': 'How much education have you completed?',
      'answers': education,
    },
    {
      'questionText': 'How much education have you completed?',
      'answers': area,
    },
    {
      'questionText': 'What is Your Gender?',
      'answers': gender,
    },
    {
      'questionText': 'What is Your Religion?',
      'answers': religon,
    },
    {
      'questionText': 'What is your race?',
      'answers': race,
    },
    {
      'questionText': 'Marital Status',
      'answers': maritalStatus,
    },
    {
      'questionText': 'Family Size',
      'answers': familySize,
    },
    {
      'questionText': 'What is Your Age Group',
      'answers': age,
    },
  ];
  var _questionIndex = 0;
  int _totalScore = 0;
  List<int> arr = [];

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      arr.clear();
    });
  }

  void _answerQuestion(int score) async {
    arr.add(score);
    log(arr.toString());

    setState(() {
      _questionIndex = _questionIndex + 1;
    });
    log(_questionIndex.toString());
    if (_questionIndex < _questions.length) {
      log('We have more questions!');
    } else {
      var floatArr = arr.map((i) => i.toDouble()).toList();
      final interpreter = await tfl.Interpreter.fromAsset('model.tflite');
      var output = List<int>.filled(1 * 5, 0).reshape([1, 5]);
      // inference
      interpreter.run([floatArr], output);

      final out = output[0].map((e) => e).toList();
      out.sort();
      // print the output
      // _totalScore = output[0][0];
      interpreter.close();
      _totalScore = ((output[0] as List).indexOf(out[out.length - 1]));
    }
  }

  @override
  Widget build(BuildContext context) {
    // var dummy = const ['Hello'];
    // dummy.add('Max');
    // print(dummy);
    // dummy = [];
    // questions = []; // does not work if questions is a const

    return Scaffold(
        body: SizedBox(
      height: MediaQuery.of(context).size.height * 1,
      child: SingleChildScrollView(
        child: _questionIndex < _questions.length
            ? Quiz(
                answerQuestion: _answerQuestion,
                questionIndex: _questionIndex,
                questions: _questions,
              )
            : Result(_totalScore, _resetQuiz),
      ),
    ));
  }
}
