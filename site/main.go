// Генератор публичного сайта rabbitfarm.click.
//
// Из одного шаблона и четырёх словарей получается четыре статические
// страницы: `/`, `/tg/`, `/uz/`, `/en/`. Поисковику нужен отдельный адрес на
// каждый язык, а человеку готовый текст без мигания чужого языка.
//
//	go run .            собрать в dist/
//	go run . -serve     собрать и отдавать dist/ на :5961 (для проверки)
//
// Зависимостей нет: только стандартная библиотека.
package main

import (
	"embed"
	"encoding/json"
	"flag"
	"fmt"
	"html/template"
	"io/fs"
	"log"
	"net/http"
	"os"
	"path"
	"path/filepath"
	"strings"
	"time"
)

//go:embed templates/*.gohtml content/*.json static
var assets embed.FS

const (
	siteURL  = "https://rabbitfarm.click"
	repoURL  = "https://github.com/MubiZero/RabbitFarm"
	defApp   = "https://app.rabbitfarm.click"
	teamID   = "P8K3DXRFR9" // Apple Team ID: не секрет, лежит в самом apple-app-site-association
	bundleID = "dev.mubi.rabbitfarm"
)

var locales = []string{"ru", "tg", "uz", "en"}

var langNames = map[string]string{"ru": "Русский", "tg": "Тоҷикӣ", "uz": "Oʻzbekcha", "en": "English"}

// Иконка модуля подбирается по порядку: словарь хранит только слова.
var moduleIcons = []string{"rabbit", "heart-straight", "grid-four", "plant", "first-aid-kit", "coins", "users"}

// Дела в разделе «Что записать»: снимок экрана на каждое.
var jobShots = []string{"feeding", "birth", "weight", "vaccination", "sale"}

type dict = map[string]any

func localePath(l string) string {
	if l == "ru" {
		return "/"
	}
	return "/" + l + "/"
}

// screen возвращает снимок экрана на языке страницы. Нет снимка на нужном
// языке: нет и картинки, чужой язык в рамке телефона хуже её отсутствия.
func screen(l, name string) string {
	file := name + ".webp"
	if l != "ru" {
		file = l + "-" + name + ".webp"
	}
	if _, err := fs.Stat(assets, path.Join("static/assets/screens", file)); err != nil {
		return ""
	}
	return "/assets/screens/" + file
}

func icon(name, class string) template.HTML {
	b, err := assets.ReadFile("static/assets/icons/" + name + ".svg")
	if err != nil {
		log.Fatalf("нет иконки %s: %v", name, err)
	}
	s := strings.Replace(strings.TrimSpace(string(b)), "<svg", `<svg class="`+class+`" aria-hidden="true" focusable="false"`, 1)
	return template.HTML(s)
}

type job struct {
	Label, Caption, Alt, Shot string
}

type page struct {
	Locale     string
	OGLocale   string
	T          dict
	Path       string
	Canonical  string
	Alternates []alt
	Langs      []langLink
	Hero       heroShots
	Jobs       []job
	Modules    []module
	Year       int
	Repo       string
	AppURL     string
	Site       string
}

type alt struct{ Hreflang, Href string }
type langLink struct {
	Code, Name, Href string
	Current          bool
}
type heroShots struct{ Left, Center, Right string }
type module struct {
	Icon       template.HTML
	Name, Text string
}

func load(l string) dict {
	b, err := assets.ReadFile("content/" + l + ".json")
	if err != nil {
		log.Fatal(err)
	}
	var d dict
	if err := json.Unmarshal(b, &d); err != nil {
		log.Fatalf("%s.json: %v", l, err)
	}
	return d
}

func sub(d dict, keys ...string) dict {
	cur := d
	for _, k := range keys {
		cur = cur[k].(map[string]any)
	}
	return cur
}

func items(v any) []dict {
	var out []dict
	for _, x := range v.([]any) {
		out = append(out, x.(map[string]any))
	}
	return out
}

func buildPage(l string, tpl *template.Template, dicts map[string]dict) []byte {
	t := dicts[l]
	p := page{Locale: l, OGLocale: ogLocale(l, t), T: t, Path: localePath(l), Canonical: siteURL + localePath(l), Year: time.Now().Year(), Repo: repoURL, Site: siteURL}
	p.AppURL = defApp + "?lang=" + l
	for _, o := range locales {
		p.Alternates = append(p.Alternates, alt{sub(dicts[o])["lang"].(string), siteURL + localePath(o)})
		p.Langs = append(p.Langs, langLink{o, langNames[o], localePath(o), o == l})
	}
	p.Alternates = append(p.Alternates, alt{"x-default", siteURL + "/"})
	p.Hero = heroShots{screen(l, "weight"), screen(l, "home"), screen(l, "birth")}
	for i, it := range items(sub(t, "click")["items"]) {
		shot := screen(l, jobShots[i])
		if shot == "" { // дело без снимка на языке страницы не показываем
			continue
		}
		p.Jobs = append(p.Jobs, job{it["label"].(string), it["caption"].(string), it["alt"].(string), shot})
	}
	for i, it := range items(sub(t, "modules")["items"]) {
		p.Modules = append(p.Modules, module{icon(moduleIcons[i], "module-icon"), it["name"].(string), it["text"].(string)})
	}
	var out strings.Builder
	if err := tpl.ExecuteTemplate(&out, "index.gohtml", p); err != nil {
		log.Fatalf("шаблон %s: %v", l, err)
	}
	return []byte(out.String())
}

func write(dist, name string, data []byte) {
	full := filepath.Join(dist, name)
	if err := os.MkdirAll(filepath.Dir(full), 0o755); err != nil {
		log.Fatal(err)
	}
	if err := os.WriteFile(full, data, 0o644); err != nil {
		log.Fatal(err)
	}
}

func copyStatic(dist string) {
	err := fs.WalkDir(assets, "static", func(p string, d fs.DirEntry, err error) error {
		if err != nil || d.IsDir() {
			return err
		}
		b, err := assets.ReadFile(p)
		if err != nil {
			return err
		}
		write(dist, strings.TrimPrefix(p, "static/"), b)
		return nil
	})
	if err != nil {
		log.Fatal(err)
	}
}

const csp = "default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data:; font-src 'self'; connect-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'self'"

func headers() string {
	return fmt.Sprintf(`/*
  X-Content-Type-Options: nosniff
  X-Frame-Options: SAMEORIGIN
  Referrer-Policy: strict-origin-when-cross-origin
  Content-Security-Policy: %s
  Cache-Control: no-cache, must-revalidate

/assets/*
  Cache-Control: public, max-age=2592000

/styles.css
  Cache-Control: public, max-age=3600, must-revalidate

/app.js
  Cache-Control: public, max-age=3600, must-revalidate

/config.json
  Cache-Control: no-cache

/.well-known/*
  Content-Type: application/json
  Cache-Control: no-cache
`, csp)
}

func build(dist string) {
	if err := os.RemoveAll(dist); err != nil {
		log.Fatal(err)
	}
	tpl := template.Must(template.New("").Funcs(template.FuncMap{
		"icon": icon,
		"dict": func() int { return 0 },
	}).ParseFS(assets, "templates/*.gohtml"))
	dicts := map[string]dict{}
	for _, l := range locales {
		dicts[l] = load(l)
	}
	for _, l := range locales {
		name := "index.html"
		if l != "ru" {
			name = l + "/index.html"
		}
		write(dist, name, buildPage(l, tpl, dicts))
	}
	copyStatic(dist)

	appURL := os.Getenv("APP_URL")
	if appURL == "" {
		appURL = defApp
	}
	cfg, _ := json.MarshalIndent(map[string]string{"appUrl": appURL, "androidApkUrl": os.Getenv("ANDROID_APK_URL")}, "", "  ")
	write(dist, "config.json", append(cfg, '\n'))

	// Проверка ссылок доменом: по этим файлам iOS и Android решают, что
	// https://rabbitfarm.click/i открывает приложение, а не браузер. Apple
	// читает файл без расширения и требует application/json без редиректа.
	write(dist, ".well-known/apple-app-site-association", []byte(fmt.Sprintf(`{
  "applinks": {
    "details": [
      {
        "appIDs": ["%s.%s"],
        "components": [
          { "/": "/i", "comment": "Приглашение работника" },
          { "/": "/i/*", "comment": "Приглашение работника" }
        ]
      }
    ]
  }
}
`, teamID, bundleID)))
	// Отпечаток ключа подписи Google появляется только после первой загрузки
	// сборки в Play Console. Нет значения: нет и файла, выдуманный
	// assetlinks.json проверку не пройдёт, но выглядел бы настроенным.
	if fp := os.Getenv("ANDROID_CERT_SHA256"); fp != "" {
		write(dist, ".well-known/assetlinks.json", []byte(fmt.Sprintf(`[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "%s",
      "sha256_cert_fingerprints": ["%s"]
    }
  }
]
`, bundleID, fp)))
	}

	var sm strings.Builder
	sm.WriteString(`<?xml version="1.0" encoding="UTF-8"?>` + "\n" + `<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">` + "\n")
	for _, l := range locales {
		sm.WriteString("  <url>\n    <loc>" + siteURL + localePath(l) + "</loc>\n")
		for _, o := range locales {
			sm.WriteString(`    <xhtml:link rel="alternate" hreflang="` + o + `" href="` + siteURL + localePath(o) + `"/>` + "\n")
		}
		sm.WriteString("  </url>\n")
	}
	sm.WriteString("</urlset>\n")
	write(dist, "sitemap.xml", []byte(sm.String()))
	write(dist, "robots.txt", []byte("User-agent: *\nAllow: /\n\nSitemap: "+siteURL+"/sitemap.xml\n"))
	write(dist, "_headers", []byte(headers()))
	fmt.Printf("Собрано %d страницы в %s\n", len(locales), dist)
}

func main() {
	serve := flag.Bool("serve", false, "после сборки отдавать dist на :5961")
	out := flag.String("out", "dist", "папка результата")
	flag.Parse()
	build(*out)
	if *serve {
		fmt.Println("http://localhost:5961")
		log.Fatal(http.ListenAndServe(":5961", http.FileServer(http.Dir(*out))))
	}
}

// ogLocale: формат Open Graph, `ru_RU`; у английского в словаре просто `en`.
func ogLocale(l string, t dict) string {
	v := strings.Replace(t["locale"].(string), "-", "_", 1)
	if !strings.Contains(v, "_") {
		return "en_US"
	}
	return v
}
