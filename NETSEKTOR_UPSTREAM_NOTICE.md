# Netİtibar Upstream / Donor Provenance

Bu repository **Netİtibar ürününün kendisi değildir** ve NetSektör müşteri-facing ürün markası olarak yeniden markalanmamalıdır.

## Upstream kimliği

- Upstream proje: **BrightBean Studio**
- Upstream repository: `brightbeanxyz/brightbean-studio`
- Bu repository'nin rolü: Netİtibar için değerlendirilen/takip edilen **UPSTREAM_DONOR** bileşen
- Upstream lisansı ve telif bildirimleri aynen korunmalıdır.

## NetSektör ilişkisi

Netİtibar, ayrı bir NetSektör ürünüdür ve kendi canonical reposu `sunsetfly/netitibar` olarak yönetilir. Bu donor repo üzerinde yapılan uyarlamalar, upstream provenance'i gizlememeli veya BrightBean Studio'nun kodunu sanki NetSektör tarafından sıfırdan üretilmiş gibi göstermemelidir.

## Marka kuralı

1. BrightBean Studio adı, lisansı, telif ve kaynak geçmişi korunur.
2. Netİtibar müşteri-facing markası bu repo üzerinde upstream kimliğinin yerine geçirilmez.
3. Netİtibar entegrasyonu gerekiyorsa ince adapter/fork delta olarak belgelenir.
4. Upstream güncelleme/SHA ve yerel değişiklikler izlenebilir tutulur.
5. Çelişki halinde `sunsetfly/netsektor-kurumsal-kimlik` Brand System v2 `UPSTREAM_BRANDING_POLICY`/donor kuralları uygulanır.

**Sınıflandırma:** `UPSTREAM_DONOR` · **Customer-facing NetSektör product:** hayır.
