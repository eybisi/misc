




#### Request

|Name|Magic|Parameters/Description
|---|---|---|
|AnaLogin | 8  |string kullanici_adi, string sifre, int token|
| AnaLoginKontrol  | 9  |   |   |
| ArtiBas  | 62  | string eski_item_id, int bulunan_item_slot_name  |   |
|ChatGonder   | 300  | int chat_bolgesi, int chat_turu, string chat, string ozal_oyuncu  |
| BinekKullan  |  75 |   |
|DeleteNPC   | 1004  | int npc_ID, int npc_baglanti_KARE  |\
| DepoAc  | 78  |   |
| DepoHareketleri  | 79   |   |
| DepoParaHareketi  | 80  |   |
| DroptanItemAl  | 45  | string droptan_alinan_item_ID, int belirlenen_slot  |
|  EpinKullanGonder | 90  |   |
|EnvanterAc   |  16 | int envanter_bolum  |
| GMduyuruGonder  |  301 |  string chat |
| GorevBitti  |  49 | int gorev_no, int gorev_veren, int gorev_liste_no  |
|GorevItemSil   | 50  | int eski_slot, string eski_slot_itemi  |
| GorevKabulEt  | 47  |int gorev_no, int gorev_veren   |
| GorevListesiGuncelle  | 46   | int cevap  |
| GorevSil  | 48  | string gorev_liste_no  |
| GrubuDevret  | 44  |int grup_uye_connection   |
| GrupBilgisiCek  | 41  |   |
| GrupBuffBilgisi  | 52  |int grup_uye_no, int grup_uye_connection   |
| GrupGonder  | 38  | int baglanti_kurulan_kisi  |
| GrupKabulEt  | 39  |  int grup_lideri_connectionID |
|GruptanAt   |43   |int grup_uye_connection   |
| GruptanCik  | 42  |   |
|HaraketPosGonder   | 2  | float xCor, float yCor, float zCor, float tikla_xCor, float tikla_yCor, float tikla_zCor, int saldirilan_tur, int saldirilan_id, int mesafe, int yuruyormu, int skill_no, int saldiri_anim_calisiyor_mu  |
| HasarVer  | 29  |int hasar_veren_ID, int kontrol_edilcek_ID, int baglanti_kare, int secilen_sey_turu, int vurus_skill_id   |
|IksirKullan   | 53  | string iksir_item_id, int slot_no  |
| Isinlan  |  72 |   |
| ItemCikar  | 22  |int bulunan_bos_slot, string kusanilan_item_id   |
| ItemGiy  |  21 | int eski_slot, int bulunan_bos_slot, string kusanma_slot_ismi, string kusanilan_item_id  |
| ItemSat  |  57 | string item_id, int item_no  |
|ItemSatinAl   | 56  | (string item_id, int item_no  |
| ItemSlotAyir  |19   | int eski_slot, int yeni_slot, string eski_slot_itemi, int ayrilcak_miktar  |
|ItemSlotBirlestir   | 18  | int eski_slot, int yeni_slot, string eski_slot_itemi  |
| ItemSlotDegistir  | 17  |int eski_slot, int yeni_slot, string eski_slot_itemi   |
| ItemSlotSil  | 20  | int eski_slot, string eski_slot_itemi  |
| KarakterleriGoster  |  11 | string kullanici_adi, string sifre  |
| KarakterPenceresiYenile  |   26|  int cevap |
|KarakterSayisiKontrol   |  13 |   |
| KarakterSec  | 12  |string kullanici_adi, int karakter_no   |
| KarakterSil  | 15  | int karakter_slot_no  |
| KarakterYarat  | 14  | string yazilan_karakter_adi, int sinif_no, string karakter_kozmetik  |
| KareDegisikligi  | 27  | int gecerli_kare  |
| KayitOl  | 10  | string kullanici_adi, string sifre  |
|KlanaGir   | 54  | int klan_no  |
| KlandanAyril  | 55  |   |
|KuleVurus   | 74  |   |
| KullanilabilirItem  |  76 |   |
| LoginGiris  |  3 | string kullanici_adi, string sifre, int char_sira_no  |
| LoginHesapSil  | 6  | string hesabisil_kullanici_adi  |
|LoginKayitOl | 5  |  string kayitol_kullanici_adi, string kayitol_sifre |
|LoginSifreDegis   |  4 | string sifredegis_kullanici_adi, string sifredegis_sifre  |
| MadeniCek  |  77 |   |
| MagazaSatinAl  |  92 |   |
| MagazaSayfaAc  |  91 |   |
|MenuGiris   | 40  |int build_no   |
|MenzildekiOyunculariSorgula   |  34 |   |
| MerhabaServer  |  1 |   |
|  MobGordu | 30  | int gorunen_oyuncu_ID, int goren_mob_ID, int baglanti_kare  |
| MobHasarVurdu  |  31 | int vuran_mob_id, int baglanti_kare  |
|MobCarpmasi   | 93  |   |
| NPCbarGuncelle  |  28 |  int kontrol_edilcek_ID, int baglanti_kare, int secilen_sey_turu |
| OtherBilgisiCek  |  35 | int other_id  |
| OyuncuKoptumuCheck  |  33 |   |
| OyuncuMenuyeDon  |37   |   |
|OyuncuYenidenCanlan   | 32  |   |
|PVPadasindami   |   73|   |
| PortalGecis  | 36  |  string portal_kodu |
| SifremiUnuttum  | 85  |   |
| SkillBarGuncelle  | 23  |string eski_slot_skill_id, int eski_slot_numara_int, string yeni_slot_skill_id, int yeni_slot_numara_int  |
| SkillOnay  |  51 | string skill_no, int other_id, int grup_1, int grup_2, int grup_3, int grup_4, int grup_5, int grup_6, int grup_7, int grup_8, int grup_9, int secilen_sey_turu  |
| SkillPuanDagit  |  24 |int skill_puan_1, int skill_puan_2, int skill_puan_3, int skill_puan_4, int skill_puan_5, int skill_puan_6, int skill_puan_7, int skill_puan_8, int skill_puan_9, int skill_puan_10, int skill_puan_11, int skill_puan_12, int skill_puan_13, int skill_puan_14, int skill_puan_15, int skill_puan_16, int skill_puan_17, int skill_puan_18, int skill_puan_19, int skill_puan_20, int skill_puan_21, int skill_puan_22, int skill_puan_23, int skill_puan_24, int skill_puan_25, int skill_puan_26, int skill_puan_27, int skill_puan_28   |
| SoketKontrol  |  1500 | hardware id !  |
| SpawnNPC  |  1003 |int baglanti_karesi, int npc_cesit, float pos_x, float pos_y, float pos_z, int rot   |
| StatMeslekArtir  |   25| string stat_meslek_cesidi, int verilen_puan  |
|TasBas  |60   | string eski_item_id, int bulunan_item_slot_name, string sihirli_tas_id, int bulunan_item_slot_name_2  |
|TasBirlestir   |  61 | string sihirli_tas_id_1, int bulunan_item_slot_name, string sihirli_tas_id_2, int bulunan_item_slot_name_2, int yeni_bos_slot  |
|TasCikar   |  59 |   string eski_item_id, int bulunan_item_slot_name, int silincek_tas_slot_no|
| TasSlotAc  |  58 | string eski_item_id, int bulunan_item_slot_name  |
|  Tester | 7  | int client_mesaji  |
| TezgahAc  | 86 |   |
|  TezgahKapat |  87 |   |
| TezgahSec  |88   |   |
| TezgahtanSatinal  |89   |   |
|  TicaretEsyaKoy | 66  | string item_id, int item_slot_no, int item_trade_slot_no |
| TicaretGonder  | 63  | int baglanti_kurulan_kisi  |
|TicaretKabulEt   | 64  | int baglanti_kurulan_kisi  |
| TicaretKapat  | 65  |   |
| TicaretOnayla  |   69|   |
|  TicaretParaKoy |   68|   |
| TicaretSayfaYenile  | 67  |   |
| TownCek  |  70 |   |
|UretimPenceresiAc   | 81  |   |
| UretimPenceresiOku  | 82  |   |
|UretimPenceresiSil   |83   |   |
|UretimPenceresiUret   | 84  |   |
| VarlikSilindi  | 71  |   |
| YetkiliAnakartBanla  | 1014  |   |
| YetkiliBaglantiyiKes  | 1009  | string hedef_oyuncu_isim  |
| YetkiliBanla  | 1013  | string hedef_oyuncu_isim, int dakika  |
|YetkiliBaslangicaGit   | 1005  | int gidis_nokta  |
|YetkiliCezaKaldir   |  1012 | string hedef_oyuncu_isim  |
| YetkiliExpAl  |  1015 |   |
| YetkiliHesaplarAc  | 1007  |   |
|YetkiliItemAl   |  1001 | int belirlenen_slot, string istenilen_item_id  |
| YetkiliParaAl  | 1008  | int miktar  |
|YetkiliSkillSifirla   | 1002  |   |
|YetkiliStatSifirla   | 1006  |   |
| YetkiliSustur  | 1011  |   |
| YetkiliYaninaisinla  | 1010  |   |
