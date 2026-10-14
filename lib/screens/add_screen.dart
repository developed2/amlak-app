import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/property.dart';
import '../providers/app_state.dart';
import '../data/sample_data.dart';

class AddScreen extends StatefulWidget {
  final VoidCallback? onSaved;
  const AddScreen({super.key, this.onSaved});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _form = GlobalKey<FormState>();
  final titleCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final areaCtrl = TextEditingController();
  final roomsCtrl = TextEditingController(text: '2');
  final descCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final imgUrlCtrl = TextEditingController();

  String city = 'تهران';
  DealType deal = DealType.sale;
  PropertyType type = PropertyType.apartment;
  final List<String> localImages = [];

  @override
  void dispose() {
    titleCtrl.dispose();
    addressCtrl.dispose();
    priceCtrl.dispose();
    areaCtrl.dispose();
    roomsCtrl.dispose();
    descCtrl.dispose();
    phoneCtrl.dispose();
    imgUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (x != null) setState(() => localImages.add(x.path));
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final images = <String>[
      ...localImages,
      if (imgUrlCtrl.text.trim().isNotEmpty) imgUrlCtrl.text.trim(),
    ];
    if (images.isEmpty) {
      images.add('https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/800/600');
    }
    final p = Property(
      id: 'u${DateTime.now().millisecondsSinceEpoch}',
      title: titleCtrl.text.trim(),
      city: city,
      address: addressCtrl.text.trim(),
      price: int.parse(priceCtrl.text.trim()),
      area: int.parse(areaCtrl.text.trim()),
      rooms: int.tryParse(roomsCtrl.text.trim()) ?? 0,
      type: type,
      deal: deal,
      description: descCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      images: images,
      lat: 35.6892,
      lng: 51.3890,
      createdAt: DateTime.now(),
      isUserAdded: true,
    );
    await Provider.of<AppState>(context, listen: false).addProperty(p);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('آگهی با موفقیت ثبت شد')),
    );
    _form.currentState!.reset();
    titleCtrl.clear();
    addressCtrl.clear();
    priceCtrl.clear();
    areaCtrl.clear();
    descCtrl.clear();
    phoneCtrl.clear();
    imgUrlCtrl.clear();
    setState(() => localImages.clear());
    widget.onSaved?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('ثبت آگهی جدید',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextFormField(
            controller: titleCtrl,
            decoration: const InputDecoration(
                labelText: 'عنوان آگهی *', border: OutlineInputBorder()),
            validator: (v) =>
                (v == null || v.trim().length < 5) ? 'عنوان کوتاه است' : null,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: city,
                  decoration: const InputDecoration(
                      labelText: 'شهر', border: OutlineInputBorder()),
                  items: [
                    for (final c in allCities.where((e) => e != 'همه'))
                      DropdownMenuItem(value: c, child: Text(c)),
                  ],
                  onChanged: (v) => setState(() => city = v ?? city),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<DealType>(
                  value: deal,
                  decoration: const InputDecoration(
                      labelText: 'معامله', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(
                        value: DealType.sale, child: Text('فروش')),
                    DropdownMenuItem(
                        value: DealType.rent, child: Text('اجاره')),
                  ],
                  onChanged: (v) => setState(() => deal = v ?? deal),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<PropertyType>(
            value: type,
            decoration: const InputDecoration(
                labelText: 'نوع ملک', border: OutlineInputBorder()),
            items: [
              for (final t in PropertyType.values)
                DropdownMenuItem(
                    value: t, child: Text(propertyTypeLabel(t))),
            ],
            onChanged: (v) => setState(() => type = v ?? type),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: addressCtrl,
            decoration: const InputDecoration(
                labelText: 'آدرس *', border: OutlineInputBorder()),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'آدرس لازم است' : null,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'قیمت (تومان) *',
                      border: OutlineInputBorder()),
                  validator: (v) => (int.tryParse((v ?? '').trim()) == null)
                      ? 'عدد معتبر وارد کنید'
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: areaCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'متراژ *', border: OutlineInputBorder()),
                  validator: (v) => (int.tryParse((v ?? '').trim()) == null)
                      ? 'عدد معتبر وارد کنید'
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: roomsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'تعداد خواب', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      labelText: 'موبایل مالک *',
                      hintText: '0912...',
                      border: OutlineInputBorder()),
                  validator: (v) => ((v ?? '').trim().length < 10)
                      ? 'شماره معتبر نیست'
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: descCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
                labelText: 'توضیحات', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: imgUrlCtrl,
            decoration: const InputDecoration(
                labelText: 'لینک عکس (اختیاری)',
                hintText: 'https://...',
                border: OutlineInputBorder()),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.image_outlined),
            label: Text(localImages.isEmpty
                ? 'انتخاب عکس از گالری'
                : '${localImages.length} عکس انتخاب شد + افزودن'),
            onPressed: _pickImage,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('ثبت آگهی'),
            onPressed: _save,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
