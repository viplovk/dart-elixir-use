import 'dart:html' as html;

void main() {
  final body = html.document.body!;
  body.children.clear();

  final style = html.StyleElement()
    ..text = '''
      :root {
        color-scheme: dark;
        font-family: Inter, ui-sans-serif, system-ui, -apple-system,
          BlinkMacSystemFont, "Segoe UI", sans-serif;
      }

      * { box-sizing: border-box; }

      body {
        margin: 0;
        min-height: 100vh;
        color: #f3f3f3;
        background:
          radial-gradient(circle at 1px 1px, rgba(255,255,255,.16) 1px, transparent 1.15px)
          0 0 / 13px 13px,
          #202224;
      }

      .page {
        min-height: 100vh;
        padding: 80px 5.6vw 120px;
      }

      .label {
        display: flex;
        align-items: center;
        gap: 5px;
        height: 20px;
        margin-bottom: 1px;
        font-size: 12px;
        line-height: 1;
        font-weight: 500;
        color: #e6e6e6;
        letter-spacing: -.01em;
      }

      .label-icon {
        position: relative;
        width: 13px;
        height: 10px;
      }

      .label-icon::before,
      .label-icon::after {
        content: "";
        position: absolute;
        border: 1px solid #e8e8e8;
        border-radius: 2px;
      }

      .label-icon::before {
        width: 8px;
        height: 7px;
        left: 0;
        top: 2px;
      }

      .label-icon::after {
        width: 8px;
        height: 7px;
        left: 4px;
        top: 0;
      }

      .hero {
        width: 100%;
        height: 31px;
        border-radius: 9px;
        background: #fafafa;
        color: #1e2a37;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: clamp(22px, 2vw, 28px);
        font-weight: 400;
        letter-spacing: -.025em;
        box-shadow:
          0 0 0 1px rgba(255,255,255,.25),
          0 1px 2px rgba(0,0,0,.18);
      }

      @media (max-width: 700px) {
        .page {
          padding: 54px 20px 80px;
        }

        .hero {
          height: 42px;
          border-radius: 10px;
          font-size: 22px;
        }

        .label {
          font-size: 11px;
        }
      }
    ''';

  html.document.head!.append(style);

  final page = html.DivElement()
    ..classes.add('page');

  final label = html.DivElement()
    ..classes.add('label');

  label.append(
    html.SpanElement()..classes.add('label-icon'),
  );

  label.append(
    html.SpanElement()..text = 'Hello World - Minimal',
  );

  final hero = html.DivElement()
    ..classes.add('hero')
    ..text = 'Hello World';

  page.children.add(label);
  page.children.add(hero);
  body.append(page);
}
