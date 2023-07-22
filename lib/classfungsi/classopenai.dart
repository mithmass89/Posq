import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenAI {
  final String apiKey = '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';
  final String modelEndpoint =
      'https://api.openai.com/v1/engines/text-davinci-003/completions';

  OpenAI();

  Future<String> getOpenAIResponse(String prompt) async {
    final response = await http.post(
      Uri.parse(modelEndpoint),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': prompt,
        'max_tokens': 150,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['choices'][0]['text'];
    } else {
      throw Exception('Failed to connect to the OpenAI API.');
    }
  }
}
