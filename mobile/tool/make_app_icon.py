# -*- coding: utf-8 -*-
"""Иконка приложения: собрать из исходника и разложить по всем платформам.

Запуск (нужен Pillow):

    python3 tool/make_app_icon.py

Исходник — кролик из Noto Emoji (U+1F407), шрифт под лицензией SIL Open Font
License 1.1, см. `tool/ICON-NOTICE.md`. Эмодзи Apple брать нельзя: их
лицензия не разрешает использование в графике приложений, а именно ими
кролик выглядит в macOS и iOS.

Генератора вроде `flutter_launcher_icons` в проекте намеренно нет: пакет
тянет зависимость и свои правила ради операции, которая случается раз в
несколько лет, и всё равно не умеет ни монохромный слой, ни windows-ico.

Файл нужен не для регулярного запуска, а чтобы иконку можно было пересобрать
из исходника, когда поменяется цвет или рисунок: собранные PNG лежат в git
и переписываются только этим скриптом.
"""
import json
import os
import urllib.request
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCE_URL = 'https://raw.githubusercontent.com/googlefonts/noto-emoji/main/png/512/emoji_u1f407.png'
SOURCE = os.path.join(ROOT, 'tool', 'rabbit-noto-512.png')

S = 1024
# AppColors.accentEmerald — акцент приложения по умолчанию — и он же глубже:
# плоская заливка на 1024 выглядит мёртвой.
TOP, BOTTOM = (0x10, 0xB9, 0x81), (0x04, 0x78, 0x57)

# Доля холста под кролика. Для обычной иконки — максимум, для слоёв, которые
# система обрезает под форму устройства, — с запасом: у adaptive-иконки
# Android гарантированно видна только центральная зона 66dp из 108dp, у
# maskable в вебе — круг в 80% ширины.
SHARE_FLAT, SHARE_ADAPTIVE, SHARE_MASKABLE = 0.70, 0.56, 0.60

ANDROID_DPI = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}


def gradient(size):
    strip = Image.new('RGB', (1, size))
    for y in range(size):
        k = y / (size - 1)
        strip.putpixel((0, y), tuple(round(t + (b - t) * k) for t, b in zip(TOP, BOTTOM)))
    return strip.resize((size, size), Image.BILINEAR)


def load_rabbit():
    if not os.path.exists(SOURCE):
        urllib.request.urlretrieve(SOURCE_URL, SOURCE)
    art = Image.open(SOURCE).convert('RGBA')
    # Прозрачные поля эмодзи обрезаем: с ними кролик кажется мельче, чем
    # занимает места, и композиция уезжает вверх.
    return art.crop(art.getbbox())


def layer(rabbit, canvas, share):
    target = round(canvas * share)
    scale = target / max(rabbit.size)
    art = rabbit.resize(
        (max(1, round(rabbit.width * scale)), max(1, round(rabbit.height * scale))),
        Image.LANCZOS)
    out = Image.new('RGBA', (canvas, canvas), (0, 0, 0, 0))
    out.paste(art, ((canvas - art.width) // 2, (canvas - art.height) // 2), art)
    return out


def save(img, path, size, keep_alpha=False):
    out = img.resize((size, size), Image.LANCZOS)
    out = out if keep_alpha else out.convert('RGB')
    os.makedirs(os.path.dirname(path), exist_ok=True)
    out.save(path)


def main():
    rabbit = load_rabbit()

    flat = gradient(S).convert('RGBA')
    flat.alpha_composite(layer(rabbit, S, SHARE_FLAT))
    flat = flat.convert('RGB')

    maskable = gradient(S).convert('RGBA')
    maskable.alpha_composite(layer(rabbit, S, SHARE_MASKABLE))
    maskable = maskable.convert('RGB')

    foreground = layer(rabbit, S, SHARE_ADAPTIVE)
    monochrome = Image.new('RGBA', foreground.size, (0, 0, 0, 0))
    monochrome.putalpha(foreground.getchannel('A'))

    # iOS и macOS: размеры диктует Contents.json, чтобы ничего не пропустить.
    # Альфа-канала в этих файлах быть не должно — App Store такие отклоняет.
    for assets in ['ios/Runner/Assets.xcassets/AppIcon.appiconset',
                   'macos/Runner/Assets.xcassets/AppIcon.appiconset']:
        path = os.path.join(ROOT, assets)
        for image in json.load(open(f'{path}/Contents.json'))['images']:
            if 'filename' not in image:
                continue
            side = float(image['size'].split('x')[0]) * float(image['scale'].rstrip('x'))
            save(flat, f"{path}/{image['filename']}", round(side))

    for bucket, k in ANDROID_DPI.items():
        res = os.path.join(ROOT, 'android/app/src/main/res', f'mipmap-{bucket}')
        save(flat, f'{res}/ic_launcher.png', round(48 * k))
        save(foreground, f'{res}/ic_launcher_foreground.png', round(108 * k), keep_alpha=True)
        save(monochrome, f'{res}/ic_launcher_monochrome.png', round(108 * k), keep_alpha=True)

    save(flat, os.path.join(ROOT, 'web/favicon.png'), 32)
    save(flat, os.path.join(ROOT, 'web/icons/Icon-192.png'), 192)
    save(flat, os.path.join(ROOT, 'web/icons/Icon-512.png'), 512)
    save(maskable, os.path.join(ROOT, 'web/icons/Icon-maskable-192.png'), 192)
    save(maskable, os.path.join(ROOT, 'web/icons/Icon-maskable-512.png'), 512)

    flat.save(os.path.join(ROOT, 'windows/runner/resources/app_icon.ico'),
              sizes=[(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)])

    print('иконки пересобраны')


if __name__ == '__main__':
    main()
