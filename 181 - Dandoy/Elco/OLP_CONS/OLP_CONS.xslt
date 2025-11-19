<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output method="xml" indent="yes"/>
  <xsl:key name="Group-by-DelAddress" match="//DELIVERY" use="CallOffData/DeliveryAddressId" />

  <xsl:template match="@* | node()">
    <xsl:apply-templates select="//Line[starts-with(., 'EDI_DC40')]"/>
  </xsl:template>
<!-- Content Description -->
  <xsl:template match="Line[starts-with(., 'EDI_DC40')]">
    <xsl:element name="EDI_DC40">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 11, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 14, 16))"/></xsl:element>
      <xsl:element name="docrel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 30, 4))"/></xsl:element>
      <xsl:element name="status"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 2))"/></xsl:element>
      <xsl:element name="direct"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 36, 1))"/></xsl:element>
      <xsl:element name="outmod"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 37, 1))"/></xsl:element>
      <xsl:element name="exprss"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 38, 1))"/></xsl:element>
      <xsl:element name="test"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 39, 1))"/></xsl:element>
      <xsl:element name="idoctyp"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 40, 30))"/></xsl:element>
      <xsl:element name="cimtyp"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 70, 30))"/></xsl:element>
      <xsl:element name="mestyp"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 100, 30))"/></xsl:element>
      <xsl:element name="mescod"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 130, 3))"/></xsl:element>
      <xsl:element name="mesfct"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 133, 3))"/></xsl:element>
      <xsl:element name="std"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 136, 1))"/></xsl:element>
      <xsl:element name="stdvrs"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 137, 6))"/></xsl:element>
      <xsl:element name="stdmes"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 143, 6))"/></xsl:element>
      <xsl:element name="sndpor"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 149, 10))"/></xsl:element>
      <xsl:element name="sndprt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 159, 2))"/></xsl:element>
      <xsl:element name="sndpfc"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 161, 2))"/></xsl:element>
      <xsl:element name="sndprn"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 163, 10))"/></xsl:element>
      <xsl:element name="sndsad"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 173, 21))"/></xsl:element>
      <xsl:element name="sndlad"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 194, 70))"/></xsl:element>
      <xsl:element name="rcvpor"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 264, 10))"/></xsl:element>
      <xsl:element name="rcvprt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 274, 2))"/></xsl:element>
      <xsl:element name="rcvpfc"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 276, 2))"/></xsl:element>
      <xsl:element name="rcvprn"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 278, 10))"/></xsl:element>
      <xsl:element name="rcvsad"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 288, 21))"/></xsl:element>
      <xsl:element name="rcvlad"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 309, 70))"/></xsl:element>
      <xsl:element name="credat"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 379, 8))"/></xsl:element>
      <xsl:element name="cretim"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 387, 6))"/></xsl:element>
      <xsl:element name="refint"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 393, 14))"/></xsl:element>
      <xsl:element name="refgrp"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 407, 14))"/></xsl:element>
      <xsl:element name="refmes"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 421, 14))"/></xsl:element>
      <xsl:element name="arckey"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 435, 70))"/></xsl:element>
      <xsl:element name="serial"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 505, 20))"/></xsl:element>
      <xsl:apply-templates select="//Line[starts-with(., 'E2EDL20')]"/>
    </xsl:element>
  </xsl:template>
<!-- Delivery header -->
  <xsl:template match="Line[starts-with(., 'E2EDL20')]">
    <xsl:element name="E2EDL20">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="vbeln"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 10))"/></xsl:element>
      <xsl:element name="vstel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 74, 4))"/></xsl:element>
      <xsl:element name="vkorg"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 78, 4))"/></xsl:element>
      <xsl:element name="lstel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 82, 2))"/></xsl:element>
      <xsl:element name="vkbur"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 84, 4))"/></xsl:element>
      <xsl:element name="lgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 88, 3))"/></xsl:element>
      <xsl:element name="ablad"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 91, 25))"/></xsl:element>
      <xsl:element name="inco1"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 116, 3))"/></xsl:element>
      <xsl:element name="inco2"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 119, 28))"/></xsl:element>
      <xsl:element name="route"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 147, 6))"/></xsl:element>
      <xsl:element name="vsbed"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 153, 2))"/></xsl:element>
      <xsl:element name="btgew"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 155, 17))"/></xsl:element>
      <xsl:element name="ntgew"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 172, 15))"/></xsl:element>
      <xsl:element name="gewei"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 187, 3))"/></xsl:element>
      <xsl:element name="volum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 190, 15))"/></xsl:element>
      <xsl:element name="voleh"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 205, 3))"/></xsl:element>
      <xsl:element name="anzpk"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 208, 5))"/></xsl:element>
      <xsl:element name="bolnr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 213, 35))"/></xsl:element>
      <xsl:element name="traty"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 248, 4))"/></xsl:element>
      <xsl:element name="traid"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 252, 20))"/></xsl:element>
      <xsl:element name="xabln"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 272, 10))"/></xsl:element>
      <xsl:element name="lifex"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 282, 35))"/></xsl:element>
      <xsl:element name="parid"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 317, 35))"/></xsl:element>
      <xsl:element name="podat"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 352, 8))"/></xsl:element>
      <xsl:element name="potim"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 360, 6))"/></xsl:element>
      <xsl:apply-templates select="//Line[starts-with(., 'ZE1EDL20_ADD000')]"/>
      <xsl:apply-templates select="//Line[starts-with(., 'E2EDL22')]"/>
      <xsl:apply-templates select="//Line[starts-with(., 'E2EDL21')]"/>
      <xsl:apply-templates select="//Line[starts-with(., 'E2EDL18')]"/>
      <xsl:apply-templates select="//Line[starts-with(., 'E2ADRM1001')]"/>
      <xsl:apply-templates select="//Line[starts-with(., 'E2EDT13001')]"/>
      <xsl:apply-templates select="//Line[starts-with(., 'E2TXTH8')]"/>
      <xsl:apply-templates select="//Line[starts-with(., 'E2EDL28')]"/>
      <xsl:apply-templates select="//Line[starts-with(., 'E2EDL24')]"/>
    </xsl:element>
  </xsl:template>
  
  <!-- Delivery header added data-->
  <xsl:template match="Line[starts-with(., 'ZE1EDL20_ADD000')]">
    <xsl:element name="ZE1EDL20_ADD000">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="btgew"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 17))"/></xsl:element>
      <xsl:element name="ntgew"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 81, 17))"/></xsl:element>
      <xsl:element name="gewei"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 98, 3))"/></xsl:element>
      <xsl:element name="LZONE"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 101, 10))"/></xsl:element>
      <xsl:element name="TAX_OFFICE"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 111, 16))"/></xsl:element>
      <xsl:element name="TAX_NUMBER"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 127, 11))"/></xsl:element>
      <xsl:element name="ZZPAG_CONTR"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 138, 1))"/></xsl:element>
      <xsl:element name="ZZAMTBL"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 139, 17))"/></xsl:element>
      <xsl:element name="WAERK"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 156, 5))"/></xsl:element>
      <xsl:element name="ZLSCH"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 161, 1))"/></xsl:element>
      <xsl:element name="NUM_DDT"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 162, 10))"/></xsl:element>
      <xsl:element name="SAMMG"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 172, 10))"/></xsl:element>
      <xsl:element name="BLDAT"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 182, 8))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!-- Delivery header descriptions-->
  <xsl:template match="Line[starts-with(., 'E2EDL22')]">
    <xsl:element name="E2EDL22">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="vstel_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 30))"/></xsl:element>
      <xsl:element name="vkorg_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 94, 20))"/></xsl:element>
      <xsl:element name="lstel_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 114, 20))"/></xsl:element>
      <xsl:element name="vkbur_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 134, 20))"/></xsl:element>
      <xsl:element name="lgnum_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 154, 25))"/></xsl:element>
      <xsl:element name="inco1_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 179, 30))"/></xsl:element>
      <xsl:element name="route_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 209, 40))"/></xsl:element>
      <xsl:element name="vsbed_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 249, 20))"/></xsl:element>
      <xsl:element name="traty_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 269, 20))"/></xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- Delivery header additional data -->
  <xsl:template match="Line[starts-with(., 'E2EDL21')]">
    <xsl:element name="E2EDL21">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="lfart"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 4))"/></xsl:element>
      <xsl:element name="bzirk"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 68, 6))"/></xsl:element>
      <xsl:element name="autlf"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 74, 1))"/></xsl:element>
      <xsl:element name="expkz"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 75, 1))"/></xsl:element>
      <xsl:element name="lifsk"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 76, 2))"/></xsl:element>
      <xsl:element name="lprio"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 78, 2))"/></xsl:element>
      <xsl:element name="kdgrp"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 80, 2))"/></xsl:element>
      <xsl:element name="berot"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 82, 20))"/></xsl:element>
      <xsl:element name="tragr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 102, 4))"/></xsl:element>
      <xsl:element name="trspg"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 106, 2))"/></xsl:element>
      <xsl:element name="aulwe"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 108, 10))"/></xsl:element>
      <xsl:apply-templates select="//Line[starts-with(., 'E2EDL23')]"/>
    </xsl:element>
  </xsl:template>
  
  <!-- Delivery header additional data description -->
  <xsl:template match="Line[starts-with(., 'E2EDL23')]">
    <xsl:element name="E2EDL23">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="lfart_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 20))"/></xsl:element>
      <xsl:element name="lprio_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 84, 20))"/></xsl:element>
      <xsl:element name="bzirk_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 104, 20))"/></xsl:element>
      <xsl:element name="lifsk_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 124, 20))"/></xsl:element>
      <xsl:element name="kdgrp_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 144, 20))"/></xsl:element>
      <xsl:element name="tragr_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 164, 20))"/></xsl:element>
      <xsl:element name="trspg_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 184, 20))"/></xsl:element>
      <xsl:element name="aulwe_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 204, 40))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!-- IDOC: Controlling (Delivery) -->
  <xsl:template match="Line[starts-with(., 'E2EDL18')]">
    <xsl:element name="E2EDL18">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="qualf"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 3))"/></xsl:element>
      <xsl:element name="param"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 67, 20))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!-- Central Address Segment Group, Main Segment -->
  <xsl:template match="Line[starts-with(., 'E2ADRM1001')]">
    <xsl:element name="E2ADRM1001">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="partner_q"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 3))"/></xsl:element>
      <xsl:element name="address_t"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 67, 1))"/></xsl:element>
      <xsl:element name="partner_id"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 68, 17))"/></xsl:element>
      <xsl:element name="jurisdic"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 85, 17))"/></xsl:element>
      <xsl:element name="language"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 102, 2))"/></xsl:element>
      <xsl:element name="formofaddr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 104, 15))"/></xsl:element>
      <xsl:element name="name1"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 119, 40))"/></xsl:element>
      <xsl:element name="name2"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 159, 40))"/></xsl:element>
      <xsl:element name="name3"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 199, 40))"/></xsl:element>
      <xsl:element name="name4"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 239, 40))"/></xsl:element>
      <xsl:element name="name_text"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 279, 50))"/></xsl:element>
      <xsl:element name="name_co"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 329, 40))"/></xsl:element>
      <xsl:element name="location"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 369, 40))"/></xsl:element>
      <xsl:element name="building"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 409, 10))"/></xsl:element>
      <xsl:element name="floor"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 419, 10))"/></xsl:element>
      <xsl:element name="room"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 429, 10))"/></xsl:element>
      <xsl:element name="street1"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 439, 40))"/></xsl:element>
      <xsl:element name="street2"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 479, 40))"/></xsl:element>
      <xsl:element name="street3"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 519, 40))"/></xsl:element>
      <xsl:element name="house_supl"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 559, 4))"/></xsl:element>
      <xsl:element name="house_rang"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 563, 10))"/></xsl:element>
      <xsl:element name="postl_cod1"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 573, 10))"/></xsl:element>
      <xsl:element name="postl_cod3"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 583, 10))"/></xsl:element>
      <xsl:element name="postl_area"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 593, 15))"/></xsl:element>
      <xsl:element name="city1"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 608, 40))"/></xsl:element>
      <xsl:element name="city2"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 648, 40))"/></xsl:element>
      <xsl:element name="postl_pbox"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 688, 10))"/></xsl:element>
      <xsl:element name="postl_cod2"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 698, 10))"/></xsl:element>
      <xsl:element name="postl_city"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 708, 40))"/></xsl:element>
      <xsl:element name="telephone1"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 748, 30))"/></xsl:element>
      <xsl:element name="telephone2"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 778, 30))"/></xsl:element>
      <xsl:element name="telefax"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 808, 30))"/></xsl:element>
      <xsl:element name="telex"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 838, 30))"/></xsl:element>
      <xsl:element name="e_mail"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 868, 70))"/></xsl:element>
      <xsl:element name="country1"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 938, 3))"/></xsl:element>
      <xsl:element name="country2"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 941, 3))"/></xsl:element>
      <xsl:element name="region"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 944, 3))"/></xsl:element>
      <xsl:element name="country_cod"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 947, 3))"/></xsl:element>
      <xsl:element name="country_txt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 950, 25))"/></xsl:element>
      <xsl:element name="tzcode"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 975, 6))"/></xsl:element>
      <xsl:element name="tzdesc"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 981, 35))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!-- 	IDoc: Deadline (delivery) -->
  <xsl:template match="Line[starts-with(., 'E2EDT13001')]">
    <xsl:element name="E2EDT13001">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="qualf"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 3))"/></xsl:element>
      <xsl:element name="vstzw"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 67, 4))"/></xsl:element>
      <xsl:element name="vstzw_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 71, 20))"/></xsl:element>
      <xsl:element name="ntanf"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 91, 8))"/></xsl:element>
      <xsl:element name="ntanz"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 99, 6))"/></xsl:element>
      <xsl:element name="ntend"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 105, 8))"/></xsl:element>
      <xsl:element name="ntenz"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 113, 6))"/></xsl:element>
      <xsl:element name="tzone_beg"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 119, 6))"/></xsl:element>
      <xsl:element name="isdd"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 125, 8))"/></xsl:element>
      <xsl:element name="isdz"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 133, 6))"/></xsl:element>
      <xsl:element name="iedd"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 139, 8))"/></xsl:element>
      <xsl:element name="iedz"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 147, 6))"/></xsl:element>
      <xsl:element name="tzone_end"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 153, 6))"/></xsl:element>
      <xsl:element name="vornr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 159, 4))"/></xsl:element>
      <xsl:element name="vstga"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 163, 4))"/></xsl:element>
      <xsl:element name="vstga_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 167, 20))"/></xsl:element>
      <xsl:element name="event"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 187, 10))"/></xsl:element>
      <xsl:element name="event_ali"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 197, 20))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!-- 	General Text Header NOT IN TEST FILE!!! -->
  <xsl:template match="Line[starts-with(., 'E2TXTH8')]">
    <xsl:element name="E2TXTH8">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="function"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 3))"/></xsl:element>
      <xsl:element name="tdobject"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 67, 10))"/></xsl:element>
      <xsl:element name="tdobname"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 77, 70))"/></xsl:element>
      <xsl:element name="tdid"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 147, 4))"/></xsl:element>
      <xsl:element name="tdspras"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 151, 1))"/></xsl:element>
      <xsl:element name="tdtexttype"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 152, 6))"/></xsl:element>
      <xsl:element name="langua_iso"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 158, 2))"/></xsl:element>
      <xsl:apply-templates select="//Line[starts-with(., 'E2TXTP8')]"/>
    </xsl:element>
  </xsl:template>
  
  <!-- 	General Text Segment NOT IN TEST FILE!!! -->
  <xsl:template match="Line[starts-with(., 'E2TXTP8')]">
    <xsl:element name="E2TXTP8">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="tdformat"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 2))"/></xsl:element>
      <xsl:element name="tdline"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 66, 132))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!-- 	Routes NOT IN TEST FILE!!! -->
  <xsl:template match="Line[starts-with(., 'E2EDL28')]">
    <xsl:element name="E2EDL28">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="route"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 6))"/></xsl:element>
      <xsl:element name="vsart"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 70, 2))"/></xsl:element>
      <xsl:element name="vsavl"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 72, 2))"/></xsl:element>
      <xsl:element name="vsanl"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 74, 2))"/></xsl:element>
      <xsl:element name="rouid"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 76, 100))"/></xsl:element>
      <xsl:element name="distz"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 176, 15))"/></xsl:element>
      <xsl:element name="medst"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 191, 3))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!-- Delivery Item -->
  <xsl:template match="Line[starts-with(., 'E2EDL24')]">
    <xsl:element name="E2EDL24">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="posnr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 6))"/></xsl:element>
      <xsl:element name="matnr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 70, 18))"/></xsl:element>
      <xsl:element name="matwa"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 88, 18))"/></xsl:element>
      <xsl:element name="arktx"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 106, 40))"/></xsl:element>
      <xsl:element name="orktx"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 146, 40))"/></xsl:element>
      <xsl:element name="sugrd"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 186, 4))"/></xsl:element>
      <xsl:element name="sudru"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 190, 1))"/></xsl:element>
      <xsl:element name="matkl"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 191, 9))"/></xsl:element>
      <xsl:element name="werks"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 200, 4))"/></xsl:element>
      <xsl:element name="lgort"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 204, 4))"/></xsl:element>
      <xsl:element name="charg"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 208, 10))"/></xsl:element>
      <xsl:element name="kdmat"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 218, 22))"/></xsl:element>
      <xsl:element name="lfimg"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 240, 15))"/></xsl:element>
      <xsl:element name="vrkme"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 255, 3))"/></xsl:element>
      <xsl:element name="lgmng"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 258, 15))"/></xsl:element>
      <xsl:element name="meins"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 273, 3))"/></xsl:element>
      <xsl:element name="ntgew"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 276, 15))"/></xsl:element>
      <xsl:element name="brgew"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 291, 15))"/></xsl:element>
      <xsl:element name="gewei"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 306, 3))"/></xsl:element>
      <xsl:element name="volum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 309, 15))"/></xsl:element>
      <xsl:element name="voleh"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 324, 3))"/></xsl:element>
      <xsl:element name="lgpbe"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 327, 10))"/></xsl:element>
      <xsl:element name="hipos"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 337, 6))"/></xsl:element>
      <xsl:element name="hievw"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 343, 1))"/></xsl:element>
      <xsl:element name="ladgr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 344, 4))"/></xsl:element>
      <xsl:element name="tragr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 348, 4))"/></xsl:element>
      <xsl:element name="vkbur"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 352, 4))"/></xsl:element>
      <xsl:element name="vkgrp"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 356, 3))"/></xsl:element>
      <xsl:element name="vtweg"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 359, 2))"/></xsl:element>
      <xsl:element name="spart"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 361, 2))"/></xsl:element>
      <xsl:element name="grkor"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 363, 3))"/></xsl:element>
      <xsl:element name="ean11"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 366, 18))"/></xsl:element>
      <xsl:element name="sernr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 384, 8))"/></xsl:element>
      <xsl:element name="aeskd"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 392, 17))"/></xsl:element>
      <xsl:element name="empst"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 409, 25))"/></xsl:element>
      <xsl:element name="mfrgr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 434, 8))"/></xsl:element>
      <xsl:element name="vbrst"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 442, 14))"/></xsl:element>
      <xsl:element name="labnk"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 456, 17))"/></xsl:element>
      <xsl:element name="abrdt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 473, 8))"/></xsl:element>
      <xsl:element name="mfrpn"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 481, 40))"/></xsl:element>
      <xsl:element name="mgrnr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 521, 10))"/></xsl:element>
      <xsl:element name="abrvw"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 531, 3))"/></xsl:element>
      <xsl:element name="kdmat35"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 534, 35))"/></xsl:element>
      <xsl:element name="kannr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 569, 35))"/></xsl:element>
      <xsl:element name="posex"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 604, 6))"/></xsl:element>
      <xsl:element name="lieffz"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 610, 17))"/></xsl:element>
      <xsl:element name="usr01"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 627, 35))"/></xsl:element>
      <xsl:element name="usr02"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 662, 35))"/></xsl:element>
      <xsl:element name="usr03"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 697, 35))"/></xsl:element>
      <xsl:element name="usr04"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 732, 10))"/></xsl:element>
      <xsl:element name="usr05"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 742, 10))"/></xsl:element>
      <xsl:element name="matnr_external"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 752, 40))"/></xsl:element>
      <xsl:element name="matnr_version"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 792, 10))"/></xsl:element>
      <xsl:element name="matnr_guid"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 802, 32))"/></xsl:element>
      <xsl:element name="matwa_external"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 834, 40))"/></xsl:element>
      <xsl:element name="matwa_version"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 874, 10))"/></xsl:element>
      <xsl:element name="matwa_guid"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 884, 32))"/></xsl:element>
      <xsl:element name="zudat"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 916, 20))"/></xsl:element>
      <xsl:element name="vfdat"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 936, 8))"/></xsl:element>
      <xsl:element name="filler"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 844, 700))"/></xsl:element>
      <xsl:apply-templates select="following::Line[starts-with(., 'E2EDL25') and position()&lt;= 1]"/>
      <xsl:apply-templates select="following::Line[starts-with(., 'E2EDL26') and position()&lt;= 2]"/>
      <xsl:apply-templates select="following::Line[starts-with(., 'E2EDL27') and position()&lt;= 3]"/>
      <xsl:apply-templates select="following::Line[starts-with(., 'E2EDL35') and position()&lt;= 4]"/>
      <xsl:apply-templates select="following::Line[starts-with(., 'E2EDL36') and position()&lt;= 5]"/>
      <xsl:apply-templates select="following::Line[starts-with(., 'E2EDL43') and position()&lt;= 6]"/>
      <xsl:apply-templates select="following::Line[starts-with(., 'E2EDL41') and position()&lt;= 7]"/>
    </xsl:element>
  </xsl:template>
  
  <!-- 	Delivery Item Added data NOT IN TEST FILE!!! -->
  <xsl:template match="Line[starts-with(., 'ZE2EDL24_ADD000')]">
    <xsl:element name="ZE2EDL24_ADD000">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="zzpaddb"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 18))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!-- 	Delivery Item remarks NOT IN TEST FILE!!! -->
  <xsl:template match="Line[starts-with(., 'ZE2EDL24_ATT000')]">
    <xsl:element name="ZE2EDL24_ATT000">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="qualf"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 3))"/></xsl:element>
      <xsl:element name="att_descr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 67, 60))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!-- 	Delivery Item Description -->
  <xsl:template match="Line[starts-with(., 'E2EDL25')]">
    <xsl:element name="E2EDL25">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="lgort_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 16))"/></xsl:element>
      <xsl:element name="ladgr_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 80, 20))"/></xsl:element>
      <xsl:element name="tragr_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 100, 20))"/></xsl:element>
      <xsl:element name="vkbur_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 120, 20))"/></xsl:element>
      <xsl:element name="vkgrp_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 140, 20))"/></xsl:element>
      <xsl:element name="vtweg_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 160, 20))"/></xsl:element>
      <xsl:element name="spart_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 180, 20))"/></xsl:element>
      <xsl:element name="mfrgr_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 200, 20))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
    <!-- 	Delivery Item Additional Data -->
  <xsl:template match="Line[starts-with(., 'E2EDL26')]">
    <xsl:element name="E2EDL26">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="pstyv"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 4))"/></xsl:element>
      <xsl:element name="matkl"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 68, 9))"/></xsl:element>
      <xsl:element name="prodh"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 77, 18))"/></xsl:element>
      <xsl:element name="umvkz"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 95, 6))"/></xsl:element>
      <xsl:element name="umvkn"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 101, 6))"/></xsl:element>
      <xsl:element name="kztlf"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 107, 1))"/></xsl:element>
      <xsl:element name="uebtk"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 108, 1))"/></xsl:element>
      <xsl:element name="uebto"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 109, 5))"/></xsl:element>
      <xsl:element name="untto"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 114, 5))"/></xsl:element>
      <xsl:element name="chspl"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 119, 1))"/></xsl:element>
      <xsl:element name="xchbw"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 120, 1))"/></xsl:element>
      <xsl:element name="posar"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 121, 1))"/></xsl:element>
      <xsl:element name="sobkz"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 122, 1))"/></xsl:element>
      <xsl:element name="pckpf"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 123, 1))"/></xsl:element>
      <xsl:element name="magrv"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 124, 4))"/></xsl:element>
      <xsl:element name="shkzg"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 128, 1))"/></xsl:element>
      <xsl:element name="koqui"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 129, 1))"/></xsl:element>
      <xsl:element name="aktnr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 130, 10))"/></xsl:element>
      <xsl:element name="kzumw"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 140, 1))"/></xsl:element>
      <xsl:element name="kvgr1"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 141, 3))"/></xsl:element>
      <xsl:element name="kvgr2"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 144, 3))"/></xsl:element>
      <xsl:element name="kvgr3"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 147, 3))"/></xsl:element>
      <xsl:element name="kvgr4"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 150, 3))"/></xsl:element>
      <xsl:element name="kvgr5"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 153, 3))"/></xsl:element>
      <xsl:element name="mvgr1"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 156, 3))"/></xsl:element>
      <xsl:element name="mvgr2"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 159, 3))"/></xsl:element>
      <xsl:element name="mvgr3"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 162, 3))"/></xsl:element>
      <xsl:element name="mvgr4"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 165, 3))"/></xsl:element>
      <xsl:element name="mvgr5"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 168, 3))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
      <!-- 	Delivery Item Additional Data Descriptions -->
  <xsl:template match="Line[starts-with(., 'E2EDL27')]">
    <xsl:element name="E2EDL27">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="pstyv_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 20))"/></xsl:element>
      <xsl:element name="matkl_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 84, 20))"/></xsl:element>
      <xsl:element name="prodh_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 104, 20))"/></xsl:element>
      <xsl:element name="werks_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 124, 30))"/></xsl:element>
      <xsl:element name="kvgr1_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 154, 20))"/></xsl:element>
      <xsl:element name="kvgr2_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 174, 20))"/></xsl:element>
      <xsl:element name="kvgr3_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 194, 20))"/></xsl:element>
      <xsl:element name="kvgr4_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 214, 20))"/></xsl:element>
      <xsl:element name="kvgr5_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 234, 20))"/></xsl:element>
      <xsl:element name="mvgr1_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 254, 40))"/></xsl:element>
      <xsl:element name="mvgr2_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 294, 40))"/></xsl:element>
      <xsl:element name="mvgr3_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 334, 40))"/></xsl:element>
      <xsl:element name="mvgr4_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 374, 40))"/></xsl:element>
      <xsl:element name="mvgr5_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 414, 40))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
        <!-- 	Export Data Delivery Item -->
  <xsl:template match="Line[starts-with(., 'E2EDL35')]">
    <xsl:element name="E2EDL35">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="stawn"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 17))"/></xsl:element>
      <xsl:element name="exprf"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 81, 5))"/></xsl:element>
      <xsl:element name="exart"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 86, 2))"/></xsl:element>
      <xsl:element name="herkl"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 88, 3))"/></xsl:element>
      <xsl:element name="herkr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 91, 3))"/></xsl:element>
      <xsl:element name="grwrt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 94, 15))"/></xsl:element>
      <xsl:element name="prefe"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 109, 1))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
    <!-- 	Export Data Delivery Item Description -->
  <xsl:template match="Line[starts-with(., 'E2EDL36')]">
    <xsl:element name="E2EDL36">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="stxt1"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 40))"/></xsl:element>
      <xsl:element name="stxt2"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 104, 40))"/></xsl:element>
      <xsl:element name="stxt3"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 144, 40))"/></xsl:element>
      <xsl:element name="stxt4"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 184, 40))"/></xsl:element>
      <xsl:element name="stxt5"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 224, 40))"/></xsl:element>
      <xsl:element name="stxt6"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 264, 40))"/></xsl:element>
      <xsl:element name="stxt7"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 304, 40))"/></xsl:element>
      <xsl:element name="exprf_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 344, 30))"/></xsl:element>
      <xsl:element name="exart_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 374, 30))"/></xsl:element>
      <xsl:element name="herkl_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 404, 15))"/></xsl:element>
      <xsl:element name="herkr_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 419, 20))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
    <!-- 	IDoc Reference -->
  <xsl:template match="Line[starts-with(., 'E2EDL43')]">
    <xsl:element name="E2EDL43">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="qualf"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 1))"/></xsl:element>
      <xsl:element name="belnr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 65, 35))"/></xsl:element>
      <xsl:element name="posnr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 100, 6))"/></xsl:element>
      <xsl:element name="datum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 106, 8))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
      <!-- Reference data ordering party -->
  <xsl:template match="Line[starts-with(., 'E2EDL41')]">
    <xsl:element name="E2EDL41">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="quali"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 3))"/></xsl:element>
      <xsl:element name="bstnr"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 67, 35))"/></xsl:element>
      <xsl:element name="bstdt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 102, 8))"/></xsl:element>
      <xsl:element name="bsark"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 110, 4))"/></xsl:element>
      <xsl:element name="ihrez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 114, 12))"/></xsl:element>
      <xsl:element name="posex"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 126, 6))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
        <!-- Reference data ordering party texts -->
  <xsl:template match="Line[starts-with(., 'E2EDL42')]">
    <xsl:element name="E2EDL42">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="bsark_bez"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 20))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
      <!-- 	General Text Header (for a delivery position) -->
  <xsl:template match="Line[starts-with(., 'E2TXTH9')]">
    <xsl:element name="E2TXTH9">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="function"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 3))"/></xsl:element>
      <xsl:element name="tdobject"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 67, 10))"/></xsl:element>
      <xsl:element name="tdobname"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 77, 70))"/></xsl:element>
      <xsl:element name="tdid"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 147, 4))"/></xsl:element>
      <xsl:element name="tdspras"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 151, 1))"/></xsl:element>
      <xsl:element name="tdtexttype"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 152, 6))"/></xsl:element>
      <xsl:element name="langua_iso"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 158, 2))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  
        <!-- 	General Text Segment -->
  <xsl:template match="Line[starts-with(., 'E2TXTP9')]">
    <xsl:element name="E2TXTP9">
      <xsl:element name="mandt"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 31, 3))"/></xsl:element>
      <xsl:element name="docnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 34, 16))"/></xsl:element>
      <xsl:element name="segnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 50, 6))"/></xsl:element>
      <xsl:element name="psgnum"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 56, 6))"/></xsl:element>
      <xsl:element name="hlevel"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 62, 2))"/></xsl:element>
      <xsl:element name="tdformat"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 64, 2))"/></xsl:element>
      <xsl:element name="tdline"><xsl:value-of select="MyScript:RemEmptySpace(substring(., 66, 132))"/></xsl:element>
    </xsl:element>
  </xsl:template>
  

  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[
      public int Counter;
      public int Counter2;
      public int MinRunSeqId;
      public Collections.Generic.List<int> MinRunSeqIdList = new Collections.Generic.List<int>();
      
      public string GetCounter(bool increment) {
        if (increment)
          Counter += 1;
          
        return Counter.ToString();
      }
      
      public string GetCounter2(bool increment) {
        if (increment)
          Counter2 += 1;
          
        return Counter2.ToString();
      }
      
      public void SetMinRunSeqId(string RunSeqId) {
        if (RunSeqId != "") {
          if (MinRunSeqId == 0)
            MinRunSeqId = Int32.Parse(RunSeqId);
        
          if (Int32.Parse(RunSeqId) < MinRunSeqId)
            MinRunSeqId = Int32.Parse(RunSeqId);
        }
      }
      
      public string GetLoadSeq(string DeliveryCount) {
        return (Int32.Parse(DeliveryCount) - MinRunSeqIdList.IndexOf(MinRunSeqId)).ToString();
      }
      
      public void AddToMinRunSeqIdList() {
        MinRunSeqIdList.Add(MinRunSeqId);
        MinRunSeqIdList.Sort();
      }
      
      public string RemEmptySpace (string input)
      {
        char[] trimChars = { ' ' };
        return input.Trim(trimChars);
      }
    ]]>
  </msxsl:script>
</xsl:stylesheet>
