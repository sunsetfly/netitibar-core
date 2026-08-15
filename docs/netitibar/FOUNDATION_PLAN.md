# Netİtibar Core — NT2-01 Foundation Plan

**Branch:** `agent/nt2-01-foundation`  
**Base:** `d85fce192e687d20e8fd7e9449a40ad7952ec7c3`

## Amaç

BrightBean baseline'ını değiştirmeden önce Netİtibar 2.0 için tekrar üretilebilir, lisans uyumlu ve güvenli bir geliştirme zemini oluşturmak.

## Foundation çıkış kriterleri

NT2-01 aşağıdaki şartlar tamamlanmadan kapanmaz:

- [x] `sunsetfly/netitibar-core` fork oluşturuldu.
- [x] Fork `main` SHA'sı kilitli BrightBean baseline ile birebir doğrulandı.
- [x] AGPL `LICENSE` upstream'den korunuyor.
- [x] Upstream CI baseline'ın ruff/pytest/gitleaks/mypy/build işleri yeşil olarak doğrulandı.
- [x] Netİtibar upstream lock politikası repo içine yazıldı.
- [ ] Native/local Python 3.12 virtualenv kurulumu yapıldı.
- [ ] PostgreSQL 16 veya uyumlu yerel PostgreSQL ile test DB oluşturuldu.
- [ ] `pip install -r requirements.txt` temiz tamamlandı.
- [ ] `ruff check .` geçti.
- [ ] `ruff format --check .` geçti.
- [ ] `mypy apps/ config/ providers/ tests/ --ignore-missing-imports` geçti.
- [ ] `pytest --cov=apps --cov-report=term-missing` geçti.
- [ ] `python manage.py check` geçti.
- [ ] Migration drift kontrolü geçti (`makemigrations --check --dry-run`).
- [ ] Python 3.13 compatibility smoke sonucu kaydedildi veya bilinçli olarak ertelendi.

## Local-first doğrulama

Netİtibar'ın kendi kalite kapısı GitHub Actions'a bağımlı değildir. Upstream workflow dosyaları fork geçmişinin parçası olarak korunabilir; ancak Netİtibar feature'larının tamamlanmış sayılması için local/native doğrulama çıktıları esas alınır.

### Önerilen ilk kurulum

```bash
python3.12 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt
cp .env.example .env
```

PostgreSQL test veritabanı için upstream CI parity hedefi PostgreSQL 16'dır.

### Kalite komutları

```bash
ruff check .
ruff format --check .
mypy apps/ config/ providers/ tests/ --ignore-missing-imports
pytest --cov=apps --cov-report=term-missing
python manage.py check
python manage.py makemigrations --check --dry-run
```

## Foundation sırasında değiştirmeyeceğimiz şeyler

Baseline doğrulaması tamamlanmadan:

- branding değiştirilmez,
- BrightBean model isimleri topluca yeniden adlandırılmaz,
- provider davranışları değiştirilmez,
- Google Reviews kodu eklenmez,
- migrations oluşturulmaz,
- upstream dependency sürümleri gereksiz yere yükseltilmez,
- `.python-version` değişikliği yapılmaz.

Bu sayede oluşabilecek bir test hatasının upstream baseline mı yoksa Netİtibar değişikliği mi olduğu kesin biçimde ayrılabilir.

## NT2-02'ye geçiş

Foundation yeşil olduktan sonra yeni branch açılır:

`agent/nt2-02-reputation-domain`

İlk domain işleri:

1. `apps/reputation` Django app'i.
2. `BusinessLocation` modeli.
3. `Review` modeli ve `InboxMessage` ile ilişki.
4. `SocialAccount.business_location` optional FK.
5. workspace izolasyon negatif testleri.
6. Google Business review provider davranışına hazırlık.

## İlk ticari teknik gate

`Google Business connect -> location -> review sync -> Unified Inbox -> review detail -> reply -> Google success -> InboxReply`

Bu gate yeşil olmadan Trendyol, Yemeksepeti veya AI reputation kapsamı başlamaz.
