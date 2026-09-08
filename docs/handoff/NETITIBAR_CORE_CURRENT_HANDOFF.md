# Netİtibar Core — Current Handoff

**Tarih:** 2026-08-15  
**Source of truth:** Bu dosya Netİtibar 2.0 ana kod tabanı için kanonik devam belgesidir.

## 1. Ürün kararı

Netİtibar 2.0, BrightBean çekirdeği üzerine kurulacaktır.

Legacy Laravel repo yeni feature geliştirmesinin ana kod tabanı değildir:

- Legacy: `sunsetfly/netitibar`
- Legacy frozen baseline: `1b82c6f32d6b3c538342246824d9df21f1ccf4b6`
- Kalıcı legacy branch: `legacy/laravel-sprint3`

Legacy repo yalnız Türkiye domain bilgisi, Google Reviews davranışı, migration/veri kaynağı ve eski kararların referansı olarak korunur.

## 2. Yeni ana repo

- Repo: `sunsetfly/netitibar-core`
- Repo türü: BrightBean fork
- Görünürlük: public
- Default branch: `main`
- Upstream: `brightbeanxyz/brightbean-studio`
- BrightBean/Netİtibar baseline SHA: `d85fce192e687d20e8fd7e9449a40ad7952ec7c3`
- Foundation branch: `agent/nt2-01-foundation`
- Foundation PR: `sunsetfly/netitibar-core#1` — OPEN + DRAFT
- Foundation branch head after bootstrap/check scripts: `1772e920e5a4b7bb9103d9191cf6bcaf6f6ca212` (handoff update commit bunun üzerine gelir)
- Lisans: AGPL-3.0; upstream LICENSE korunacaktır.

## 3. Baseline kanıtı

Fork oluşturulduktan sonra `sunsetfly/netitibar-core/main` head'i tam olarak kilitlenen BrightBean SHA ile eşleşmiştir.

Upstream aynı SHA için CI run `31685593504`:

- ruff lint/format: success
- pytest: success
- gitleaks: success
- mypy: success
- Docker build: success

Bu sadece upstream kanıtıdır. Netİtibar tarafında native/local tekrar üretim yapılmadan NT2-01 bitmiş sayılmaz.

Fork PR head'i için GitHub Actions workflow run bulunmadı. Netİtibar kalite kararı GitHub Actions'a bağlı değildir; local/native doğrulama esastır.

## 4. Runtime ve local test notu

Upstream `.python-version` = `3.13` iken:

- CI Python = `3.12`
- `pyproject.toml` ruff target = `py312`
- mypy python_version = `3.12`

Kural: İlk local baseline Python 3.12 ile upstream CI parity olarak doğrulanır. Sonra 3.13 compatibility smoke değerlendirilir. Baseline doğrulanmadan runtime target dosyaları değiştirilmez.

BrightBean local development SQLite ile Docker/PostgreSQL olmadan ayağa kalkabilir. Ancak `config/settings/test.py` tam pytest veritabanını PostgreSQL olarak sabitler. Bu nedenle doğrulama iki aşamalıdır:

1. SQLite native smoke: dependency check, migrate, Django check, migration drift, ruff, mypy.
2. PostgreSQL full parity: tam pytest + coverage.

## 5. BrightBean'da doğrulanan hazır reputation altyapısı

Kod incelemesinde:

- `apps/inbox/models.py` içinde `InboxMessage.MessageType.REVIEW` zaten var.
- Inbox sync engine provider'dan gelen `message_type` değerini kalıcı inbox mesajına taşıyor.
- Review tipi reply routing'de comment-like kabul edilerek `provider.reply_to_comment(...)` çağrılıyor.
- Provider base contract `get_messages(...)` ve `reply_to_comment(...)` extension point'lerini zaten sağlıyor.
- SocialAccount OAuth tokenları `EncryptedTextField` ile tutuluyor.
- Workspace scoped manager ve inbox view'larında workspace membership/filter mekanizmaları mevcut.

Sonuç: Netİtibar ikinci bir review inbox yazmayacak. BrightBean inbox'ı reputation metadata ile genişletilecek.

## 6. NT2-01 — Foundation

Tamamlandı:

- [x] Fork oluşturuldu.
- [x] `main` baseline SHA doğrulandı.
- [x] `agent/nt2-01-foundation` branch'i exact baseline SHA'dan açıldı.
- [x] upstream lock politikası eklendi.
- [x] foundation planı eklendi.
- [x] upstream CI green kanıtı kaydedildi.
- [x] Draft foundation PR #1 açıldı.
- [x] `scripts/netitibar_bootstrap_local.sh` eklendi.
- [x] `scripts/netitibar_foundation_check.sh` eklendi (`smoke` / `full`).

Açık:

- [ ] Kullanıcı bilgisayarında Python 3.12 bootstrap
- [ ] dependency install
- [ ] SQLite smoke PASS
- [ ] PostgreSQL local test DB
- [ ] full pytest PASS
- [ ] foundation PR merge kararı

## 7. Kullanıcının çalıştıracağı exact local bootstrap

Yeni bir terminalde:

```bash
cd ~
git clone https://github.com/sunsetfly/netitibar-core.git
cd netitibar-core
git checkout agent/nt2-01-foundation
bash scripts/netitibar_bootstrap_local.sh
```

Eğer repo daha önce klonlandıysa yeniden clone etme; mevcut checkout'ta:

```bash
git fetch origin
git checkout agent/nt2-01-foundation
git pull --ff-only
bash scripts/netitibar_bootstrap_local.sh
```

Script Python 3.12 bulunamazsa güvenli biçimde durur. Başarılı olursa son satır:

`BOOTSTRAP + SMOKE PASS`

olmalıdır.

Tam PostgreSQL parity daha sonra:

```bash
bash scripts/netitibar_foundation_check.sh full
```

## 8. NT2-02 — Reputation Domain tasarımı

Foundation gate sonrasında ayrı branch/PR:

`agent/nt2-02-reputation-domain`

İlk veri modeli:

- `BusinessLocation`
- `Review`
- `ReviewSource` yalnız gerçekten ayrı entity gerektirirse; aksi durumda SocialAccount + Review metadata ile gereksiz model yaratma
- `SocialAccount.business_location` optional FK
- `Review.inbox_message` OneToOne
- `platform_review_id`
- rating
- reviewer metadata
- review/reply timestamps
- platform reply state
- normalized raw payload

İzolasyon kuralı: workspace A hiçbir şekilde workspace B'nin BusinessLocation/Review/InboxMessage kaydını okuyamaz, güncelleyemez veya yanıtlayamaz. Negatif testler zorunludur.

## 9. NT2-03 — Google Reviews E2E

BrightBean `providers/google_business.py` şu anda OAuth/account/location/post publishing/post analytics sağlıyor; review fetch/reply yok.

Legacy Laravel'deki davranış kaynakları:

- review pagination
- average rating / total review count
- review normalization
- reply-to-review
- refresh token
- mock geliştirme senaryoları

Bunlar satır satır PHP->Python çevrilmez; BrightBean provider contract'a native olarak yeniden uygulanır.

Hedef:

`Google connect -> BusinessLocation -> review sync -> InboxMessage(REVIEW) -> Review metadata -> reply -> platform success -> InboxReply`

## 10. Ürün kapsam sırası

Google review E2E yeşil olmadan kapsam büyütülmez.

Sonraki sıra:

1. Facebook + Instagram reputation akışlarının normalize edilmesi
2. Trendyol — erişim/API şartı doğrulandıktan sonra
3. Yemeksepeti — erişim/API şartı doğrulandıktan sonra
4. Hepsiburada / hospitality provider'ları
5. Türkçe sentiment/topic/reply draft
6. Netİtibar Score
7. review invitation — WhatsApp/SMS/QR/e-mail
8. bayi / white-label / billing
9. NetSektör ekosistem entegrasyonları

## 11. Upstream davranışı

GitHub'daki `Sync fork` otomatik geliştirme yöntemi değildir. Upstream update için ayrı diff/review/test/PR uygulanır.

Upstream history ve AGPL attribution korunur. Netİtibar geliştirmeleri mümkün olduğunca modüler app/provider extension olarak yapılır; upstream ile gereksiz çatışma yaratacak toplu rename/refactor ilk fazlarda yapılmaz.

## 12. Exact next execution

Bir sonraki oturumda yalnız `devam` denirse:

1. Bu dosyayı source-of-truth kabul et.
2. `sunsetfly/netitibar-core/main`, foundation branch ve PR #1 drift'ini doğrula.
3. Upstream BrightBean head değişmişse otomatik sync etme; yalnız diff/risk olarak değerlendir.
4. Kullanıcının `netitibar_bootstrap_local.sh` çıktısını incele.
5. `BOOTSTRAP + SMOKE PASS` varsa SQLite/local smoke gate'ini kapat.
6. Hata varsa feature koduna geçmeden kök nedeni foundation branch'te çöz.
7. PostgreSQL full parity testini tamamla veya açık gate olarak net biçimde tut.
8. Foundation gate kabul edildikten sonra `agent/nt2-02-reputation-domain` branch/PR'ını exact foundation head'den başlat.
9. Önce domain + isolation tests; ardından Google review provider.

## 13. Değişmez kurallar

- `main` üzerine doğrudan feature yazma.
- BrightBean upstream'i floating main olarak takip etme.
- Baseline ve feature düzeltmelerini aynı PR'da karıştırma.
- AGPL lisans/notices bütünlüğünü bozma.
- Secret/token commit etme.
- Cross-workspace negatif test olmadan reputation modeli merge etme.
- Google review E2E gate'i bitmeden Türkiye marketplace veya AI katmanına geçme.
