import 'package:flutter/material.dart';
import 'package:travel_app/models/retrieve_model.dart';

class ResultScreen extends StatefulWidget {
  final RetrieveResult result;
  final Function(List<String>) setKeyWords;

  const ResultScreen(
      {super.key, required this.result, required this.setKeyWords});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<String> selectedKeywords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      appBar: AppBar(
        title: Text('Kết quả'),
        backgroundColor: Color(0xFF222222),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoBox("Địa điểm", widget.result.diaDiem, context),
              const SizedBox(height: 16),
              _buildInfoBox("Mô tả", widget.result.moTa, context),
              const SizedBox(height: 16),
              const Text(
                "Keywords:",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 255, 87, 51),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: widget.result.keywords
                    .map((keyword) => _buildKeywordBox(keyword))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    widget.setKeyWords(selectedKeywords);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 87, 51),
                  ),
                  child:
                      Text('Tìm kiếm', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String label, String content, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Color.fromARGB(255, 255, 87, 51),
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color.fromARGB(255, 255, 87, 51),
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordBox(String keyword) {
    bool isSelected = selectedKeywords.contains(keyword);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedKeywords.remove(keyword);
          } else {
            selectedKeywords.add(keyword);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color:
              isSelected ? Color.fromARGB(255, 255, 87, 51) : Colors.grey[850],
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Color.fromARGB(255, 255, 87, 51),
            width: 2.0,
          ),
        ),
        child: Text(
          keyword,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}
