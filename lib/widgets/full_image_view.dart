import '../export_all.dart';

class FullImageView extends StatelessWidget {
  final String imagePath;
 

  const FullImageView({
    super.key,
    required this.imagePath,
    
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: Hero(
          tag: imagePath,
          child: InteractiveViewer(
            child: imagePath.startsWith('http')
                ? Image.network(imagePath, fit: BoxFit.contain)
                : Image.file(File(imagePath), fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
