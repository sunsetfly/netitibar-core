# Netİtibar Core — Upstream Baseline Lock

**Durum:** LOCKED  
**Tarih:** 2026-08-15

## Kaynak

- Netİtibar Core fork: `sunsetfly/netitibar-core`
- Upstream: `brightbeanxyz/brightbean-studio`
- Default branch: `main`
- Kilitli baseline SHA: `d85fce192e687d20e8fd7e9449a40ad7952ec7c3`
- Lisans: AGPL-3.0

Bu SHA Netİtibar 2.0 geliştirmesinin kanonik BrightBean başlangıç noktasıdır. Netİtibar feature geliştirmeleri floating upstream `main` üzerine kurulmayacaktır.

## Fork doğrulaması

2026-08-15 tarihinde `sunsetfly/netitibar-core/main` head'i birebir `d85fce192e687d20e8fd7e9449a40ad7952ec7c3` olarak doğrulandı. Fork oluşturulduktan sonra baseline üzerinde kullanıcıya/Netİtibar'a ait feature değişikliği yapılmamıştır.

## Upstream CI kanıtı

Aynı SHA için BrightBean upstream CI run `31685593504` başarıyla tamamlanmıştır. Yeşil işler:

- `Lint (ruff)` — success
- `Test (pytest)` — success
- `Secret scan (gitleaks)` — success
- `Type check (mypy)` — success
- `Docker build` — success

Bu sonuç upstream baseline'ın kendi CI ortamında yeşil olduğunu kanıtlar. Netİtibar tarafında ayrıca bağımsız local/native tekrar üretim zorunludur; upstream CI sonucu bunun yerine geçmez.

## Runtime / kalite hedefi

Upstream'de iki farklı Python sinyali vardır:

- `.python-version`: `3.13`
- `pyproject.toml` ruff/mypy hedefi ve `.github/workflows/ci.yml`: Python `3.12`

Netİtibar baseline doğrulama kuralı:

1. İlk tekrar üretim Python 3.12 üzerinde yapılır; bu upstream CI parity ortamıdır.
2. Baseline 3.12'de yeşil olduktan sonra Python 3.13 smoke/compatibility kontrolü yapılabilir.
3. Bu iki sinyal uzlaştırılmadan `.python-version` veya type/lint target'ları keyfi değiştirilmez.

## Ana teknoloji baseline'ı

- Django `>=5.1,<5.2`
- PostgreSQL (upstream CI: PostgreSQL 16)
- `psycopg[binary]`
- HTMX + django-tailwind
- django-background-tasks
- django-ninja REST API
- MCP SDK + OAuth 2.1 authorization server
- pytest + pytest-django
- ruff
- mypy + django-stubs
- gitleaks

## Upstream sync politikası

Yeni BrightBean commit'leri otomatik alınmaz. Her upstream güncellemesi için:

1. mevcut Netİtibar baseline ile upstream target SHA arasında diff çıkar,
2. migrations ve veri modeli değişiklikleri incelenir,
3. provider/API/OAuth/security değişiklikleri incelenir,
4. upstream testleri local çalıştırılır,
5. Netİtibar contract ve isolation testleri çalıştırılır,
6. ayrı upstream-sync branch/PR açılır,
7. ancak doğrulandıktan sonra Netİtibar ana hattına alınır.

## Değişmez kurallar

- `main` üzerine doğrudan feature yazma.
- `Sync fork` düğmesini gelişigüzel kullanma.
- Upstream `main`'e floating bağımlılık kurma.
- AGPL `LICENSE` ve upstream copyright/notice bütünlüğünü bozma.
- Secret/token/credential commit etme.
- Baseline hatasını Netİtibar feature değişikliğiyle aynı PR'da düzeltme.

## Sonraki gate

`agent/nt2-01-foundation` branch'i yalnız foundation ve tekrar üretilebilirlik işlerini taşır. Reputation feature kodu NT2-02 branch/PR'ında başlayacaktır.
