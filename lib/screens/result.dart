import 'dart:developer';

import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final VoidCallback resetHandler;

  Result(this.resultScore, this.resetHandler);

  String get resultPhrase {
    String resultText;
    if (resultScore == 0) {
      resultText =
          """1.	Engage in regular physical activity such as walking or jogging.
2.	Maintain a regular sleep schedule to improve sleep quality.
3.	Practice relaxation techniques like meditation or yoga.
4.	Connect with family and friends regularly.
5.	Take breaks from work or daily routine to engage in enjoyable activities.
6.	Keep a journal to record thoughts and feelings.
7.	Avoid alcohol and drugs.
8.	Practice self-care activities such as taking a hot bath or reading a book.
9.	Set small achievable goals.
10.	Challenge negative thoughts with positive affirmations.
11.	Try a new hobby or activity to increase enjoyment and pleasure.
12.	Get outside in nature and enjoy the fresh air and sunshine.
13.	Listen to music or create a playlist of uplifting songs.
14.	Incorporate healthy foods into your diet.
15.	Read a self-help book or seek advice from a mentor.
16.	Attend a support group or therapy session.
17.	Take a break from social media and screens.
18.	Create a gratitude journal to focus on the positive aspects of life.
19.	Learn a new skill or take an online course.
20.	Practice self-compassion and treat yourself with kindness.
""";
    } else if (resultScore == 1) {
      resultText =
          """1.	Consider talking to a therapist or mental health professional.
2.	Incorporate healthy foods into your diet.
3.	Identify and eliminate sources of stress.
4.	Focus on self-improvement through hobbies or learning a new skill.
5.	Set achievable daily routines and schedules.
6.	Get involved in community events or volunteering.
7.	Practice gratitude and positivity.
8.	Consider joining a support group.
9.	Take time off from work or school if necessary.
10.	Schedule regular check-ins with friends and family.
11.	Create a list of things you enjoy doing and make time for them regularly.
12.	Develop a consistent self-care routine that includes physical activity, healthy eating, and relaxation techniques.
13.	Write down positive affirmations and read them regularly.
14.	Plan a weekend getaway or vacation to recharge and rejuvenate.
15.	Attend a meditation or mindfulness class.
16.	Explore different types of therapy such as cognitive-behavioral therapy or interpersonal therapy.
17.	Set boundaries with others and prioritize your own needs.
18.	Reach out to a trusted friend or family member when feeling down.
19.	Attend a self-improvement workshop or seminar.
20.	Use positive visualization techniques to imagine positive outcomes and successes.

""";
    } else if (resultScore == 2) {
      resultText = """1.	Seek professional help from a mental health provider.
2.	Create a support system with friends and family.
3.	Consider medication options with a healthcare professional.
4.	Increase physical activity levels with structured exercise routines.
5.	Avoid alcohol and drug use.
6.	Practice deep breathing and progressive muscle relaxation techniques.
7.	Set realistic short-term and long-term goals.
8.	Find ways to incorporate meaningful activities into daily life.
9.	Prioritize self-care activities like getting enough sleep and eating well.
10.	Limit social media and news consumption to reduce stress.
11.	Identify and address negative thought patterns and beliefs through therapy.
12.	Build a network of supportive individuals who understand and accept you.
13.	Consider joining a peer support group for individuals with depression.
14.	Challenge negative self-talk with positive affirmations and self-compassion.
15.	Engage in creative outlets such as painting or writing to express emotions.
16.	Attend group therapy sessions to connect with others going through similar experiences.
17.	Develop a self-care plan with specific activities to prioritize each day.
18.	Identify and address any underlying trauma or past experiences contributing to depression.
19.	Use mood tracking tools or apps to monitor progress and identify triggers.
20.	Attend workshops or seminars focused on coping with depression or building resiliency.
""";
    } else if (resultScore == 3) {
      resultText =
          """1.	Seek immediate professional help from a mental health provider.
2.	Consider hospitalization or residential treatment if necessary.
3.	Develop a crisis plan with trusted individuals.
4.	Engage in structured, intensive therapy such as cognitive-behavioral therapy or dialectical behavior therapy.
5.	Work with a healthcare professional to explore medication options.
6.	Connect with a support group for individuals with severe depression.
7.	Consider electroconvulsive therapy (ECT) if recommended by a healthcare professional.
8.	Develop a routine that includes physical activity, healthy eating, and self-care activities.
9.	Practice relaxation techniques such as guided imagery or progressive muscle relaxation.
10.	Create a list of emergency contacts for times of crisis.
11.	Work with a therapist to develop coping strategies for managing suicidal thoughts or self-harm urges.
12.	Participate in recreational activities or hobbies to increase enjoyment and pleasure.
13.	Attend support groups for loved ones affected by depression.
14.	Identify and address any underlying trauma or past experiences contributing to depression.
15.	Seek help from a financial advisor or credit counseling service to address financial stressors.
16.	Identify and address any co-occurring substance abuse or addiction issues.
17.	Connect with a spiritual or religious community for support.
18.	Participate in peer-led programs such as wellness recovery action planning (WRAP).
19.	Create a crisis kit with soothing items such as aromatherapy oils, calming music, or coloring books.
20.	Consider alternative treatments such as acupuncture or massage therapy under the guidance of a healthcare professional.

""";
    } else {
      resultText = """1.	Seek immediate emergency medical attention.
2.	Consider hospitalization or residential treatment in a specialized facility.
3.	Work with a team of mental health professionals including a psychiatrist and therapist.
4.	Explore medication options under close supervision.
5.	Connect with a support group for individuals with extremely severe depression.
6.	Participate in intensive therapy such as cognitive-behavioral therapy or psychodynamic therapy.
7.	Consider electroconvulsive therapy (ECT) if recommended by a healthcare professional.
8.	Create a plan for crisis management and connect with a crisis line.
9.	Develop a routine that includes self-care activities, healthy eating, and physical activity.
10.	Identify and address any co-occurring disorders such as anxiety or personality disorders.
11.	Work with a therapist to develop coping strategies for managing severe symptoms.
12.	Consider long-term residential treatment or day programs for intensive support.
13.	Practice relaxation techniques such as mindfulness meditation or yoga.
14.	Connect with a support system of friends and family who can provide emotional support.
15.	Consider group therapy or support groups for loved ones affected by depression.
16.	Work with a financial advisor or credit counseling service to address financial stressors.
17.	Participate in alternative treatments such as art therapy or animal-assisted therapy.
18.	Set small achievable goals to build confidence and self-esteem.
19.	Identify and address any negative thought patterns and beliefs through therapy.
20.	Work with a spiritual or religious leader to address existential concerns and find meaning in life.

""";
    }
    log(resultScore.toString());
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            resultPhrase,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              wordSpacing: 3,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.left,
          ),
          ElevatedButton(
            onPressed: resetHandler,
            child: const Text(
              'Restart Quiz!',
            ),
          ),
        ],
      ),
    );
  }
}
