import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoritesPage extends StatefulWidget {
  final int userId;

  FavoritesPage({required this.userId});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<ImageLocation>> _imageLocationsFuture;

  @override
  void initState() {
    super.initState();
    _imageLocationsFuture = fetchFavoriteImages();
  }

  Future<List<ImageLocation>> fetchFavoriteImages() async {
    final responseInteraccion = await http.get(
      Uri.parse('https://arthub.somee.com/api/Interaccion'),
      headers: {'accept': '*/*'},
    );

    final responsePublicacion = await http.get(
      Uri.parse('https://arthub.somee.com/api/Publicacion'),
      headers: {'accept': '*/*'},
    );

    if (responseInteraccion.statusCode == 200 && responsePublicacion.statusCode == 200) {
      final List<dynamic> dataInteraccion = json.decode(responseInteraccion.body);
      final List<dynamic> dataPublicacion = json.decode(responsePublicacion.body);

      final List<int> favoriteIds = dataInteraccion
          .where((interaction) => interaction['idUsuario'] == widget.userId && interaction['like'] == false)
          .map<int>((interaction) => interaction['idPublicacion'])
          .toList();

      final List<ImageLocation> favoriteImages = dataPublicacion
          .where((image) => favoriteIds.contains(image['idPublicacion']))
          .map((image) => ImageLocation(
                name: image['titulo'].toString(),
                imageUrl: image['archivo'].toString(),
              ))
          .toList();

      return favoriteImages;
    } else {
      throw Exception('Failed to load favorite images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ImageLocation>>(
      future: _imageLocationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              children: [
                for (final imageLocation in snapshot.data!)
                  ImageParallaxItem(
                    imageUrl: imageLocation.imageUrl,
                    name: imageLocation.name,
                  ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}

class ImageLocation {
  const ImageLocation({
    required this.name,
    required this.imageUrl,
  });

  final String name;
  final String imageUrl;
}

class ImageParallaxItem extends StatefulWidget {
  ImageParallaxItem({
    Key? key,
    required this.imageUrl,
    required this.name,
  }) : super(key: key);

  final String imageUrl;
  final String name;


  @override
  _ImageParallaxItemState createState() => _ImageParallaxItemState();
}

class _ImageParallaxItemState extends State<ImageParallaxItem> {
  bool isLiked = true;
    final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildParallaxBackground(context),
              _buildGradient(),
              _buildTitleAndSubtitle(),
              _buildLikeButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context)!,
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        Image.network(
          widget.imageUrl,
          key: _backgroundImageKey,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikeButton() {
    return Positioned(
      right: 16,
      bottom: 16,
      child: IconButton(
        icon: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
          size: 32,
        ),
        onPressed: () {
          setState(() {
            isLiked = !isLiked;
          });
        },
      ),
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);

  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox,
    );

    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
        (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size!;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    context.paintChild(
      0,
      transform:
          Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}
