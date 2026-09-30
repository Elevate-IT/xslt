<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                >
  
  
  <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
  
  
  <xsl:key name="GroupBy-ActieCode_TaakNr_Productcode_Redencode_SSCC_Lotnr_THT" match="//ItemLedgerEntry"
    use="concat(Process, '-', ActieCode, '-', Taak_Nr, '-', Productcode, '-', Redencode, '-', SSCC, '-', Lotnr, '-', THT)" />
  
  
  <xsl:template match="/">
    <xsl:apply-templates select="Message/ItemLedgerEntries" />
  </xsl:template>
  
  
  <xsl:template match="Message/ItemLedgerEntries">
    <xsl:for-each select="ItemLedgerEntry[count(. | key('GroupBy-ActieCode_TaakNr_Productcode_Redencode_SSCC_Lotnr_THT', concat(Process, '-', ActieCode, '-', Taak_Nr, '-', Productcode, '-', Redencode, '-', SSCC, '-', Lotnr, '-', THT))[1]) = 1]">
      <xsl:sort select="InitialSort" data-type="number" />
      <xsl:sort select="Colli" data-type="number" />
      <xsl:sort select="Datum_creatie" />
      <xsl:sort select="Tijd_creatie" />
      <xsl:variable name="LineKey" select="concat(Process, '-', ActieCode, '-', Taak_Nr, '-', Productcode, '-', Redencode, '-', SSCC, '-', Lotnr, '-', THT)" />
      <xsl:if test="$LineKey != '-------'">
        <!--kolom A-->
        <xsl:value-of select="Actie" />
        <xsl:text>;</xsl:text>
        <!--kolom B-->
        <xsl:value-of select="ActieCode" />
        <xsl:text>;</xsl:text>
        <!--kolom C-->
        <xsl:value-of select="Order_Nr" />
        <xsl:text>;</xsl:text>
        <!--kolom D-->
        <xsl:value-of select="Taak_Nr" />
        <xsl:text>;</xsl:text>
        <!--kolom E-->
        <xsl:value-of select="EAN_pallet" />
        <xsl:text>;</xsl:text>
        <!--kolom F-->
        <xsl:value-of select="EAN_colli" />
        <xsl:text>;</xsl:text>
        <!--kolom G-->
        <xsl:value-of select="Productcode" />
        <xsl:text>;</xsl:text>
        <!--kolom H-->
        <xsl:value-of select="Redencode" />
        <xsl:text>;</xsl:text>
        <!--kolom I-->
        <xsl:value-of select="Omschrijving" />
        <xsl:text>;</xsl:text>
        <!--kolom J-->
        <xsl:value-of select="SSCC" />
        <xsl:text>;</xsl:text>
        <!--kolom k-->
        <xsl:value-of select="Lotnr" />
        <xsl:text>;</xsl:text>
        <!--kolom L-->
        <xsl:value-of select="THT" />
        <xsl:text>;</xsl:text>
        <!--kolom M-->
        <xsl:value-of select="sum(key('GroupBy-ActieCode_TaakNr_Productcode_Redencode_SSCC_Lotnr_THT',$LineKey)/Colli)" />
        <xsl:text>;</xsl:text>
        <!--kolom N-->
        <xsl:value-of select="Behandelaar" />
        <xsl:text>;</xsl:text>
        <!--kolom O-->
        <xsl:value-of select="Datum_creatie" />
        <xsl:text>;</xsl:text>
        <!--kolom P-->
        <xsl:value-of select="Tijd_creatie" />
        <xsl:text>;</xsl:text>
        <xsl:text>&#10;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
