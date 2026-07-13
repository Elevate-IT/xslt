<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  
  <xsl:output method="xml" omit-xml-declaration="no" indent="yes"/>
  
  <xsl:key name="GroupBy-Actie_ActieCode_TaakNr_Productcode_Redencode_SSCC_Lotnr_THT" match="//ItemLedgerEntry"
    use="concat(Process, '-', Actie, '-', ActieCode, '-', Taak_Nr, '-', Productcode, '-', Redencode, '-', SSCC, '-', Lotnr, '-', THT)" />
  
  <xsl:key name="GroupBy-Actie_ActieCode_Productcode_Redencode_SSCC_Lotnr_THT" match="//ItemLedgerEntry"
    use="concat(Process, '-', Actie, '-', ActieCode, '-', Productcode, '-', Redencode, '-', SSCC, '-', Lotnr, '-', THT)" />
  
  <xsl:template match="/">
    <xsl:element name="Message">
      <xsl:apply-templates select="Message/ItemLedgerEntries" />
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="Message/ItemLedgerEntries">
    <xsl:element name="ItemLedgerEntries">
      <xsl:for-each select="ItemLedgerEntry[count(. | key('GroupBy-Actie_ActieCode_Productcode_Redencode_SSCC_Lotnr_THT', concat(Process, '-', Actie, '-', ActieCode, '-', Productcode, '-', Redencode, '-', SSCC, '-', Lotnr, '-', THT))[1]) = 1]">
        <xsl:variable name="LineKey" select="concat(Process, '-', Actie, '-', ActieCode, '-', Productcode, '-', Redencode, '-', SSCC, '-', Lotnr, '-', THT)" />
        <xsl:if test="$LineKey != '-------'">
          
          <xsl:variable name="TaakNr">
            <xsl:choose>
              <xsl:when test="Process = 'WOV'">
                <xsl:variable name="OrderNr" select="Order_Nr"/>
                <xsl:value-of select="//ItemLedgerEntry[Process = 'WOV'][Order_Nr = $OrderNr][1]/Taak_Nr" />
              </xsl:when>
              <xsl:when test="Process = 'WMSTRANSFE'">
                <xsl:variable name="EntryNo">
                  <xsl:choose>
                    <xsl:when test="EntryNo &lt; RelatedEntryNo">
                      <xsl:value-of select="EntryNo" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="RelatedEntryNo" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="LedgerEntry" select="//ItemLedgerEntry[Process = 'WMSTRANSFE'][EntryNo = $EntryNo]" />
                <xsl:variable name="TaskNr" select="//ItemLedgerEntry[Process = 'WMSTRANSFE'][Actie = $LedgerEntry/Actie][Productcode = $LedgerEntry/Productcode][SSCC = $LedgerEntry/SSCC][Lotnr = $LedgerEntry/Lotnr][THT = $LedgerEntry/THT][1]/Taak_Nr" />
                <xsl:choose>
                  <xsl:when test="$LedgerEntry/Redencode = '0009'">
                    <xsl:value-of select="concat('CTAS', substring($TaskNr, 5))" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$TaskNr" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="Process = 'WMSDOCVAL'">
                <xsl:value-of select="key('GroupBy-Actie_ActieCode_Productcode_Redencode_SSCC_Lotnr_THT',$LineKey)/Taak_Nr[1]" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="SourceSSCC = ''">
                    <xsl:value-of select="key('GroupBy-Actie_ActieCode_Productcode_Redencode_SSCC_Lotnr_THT',$LineKey)/Taak_Nr[1]" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:variable name="SourceSSCC" select="SourceSSCC" />
                    <xsl:value-of select="//ItemLedgerEntry[SSCC = $SourceSSCC][1]/Taak_Nr" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          
          <xsl:element name="ItemLedgerEntry">
            <xsl:element name="InitialSort">
              <xsl:choose>
                <xsl:when test="Process = 'WMSDOCVAL'">
                  <xsl:variable name="CurrentTaakNr" select="Taak_Nr" />
                  <xsl:value-of select="//ItemLedgerEntry[Process = 'WMSDOCVAL'][Taak_Nr = $CurrentTaakNr][1]/EntryNo" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring($TaakNr, 6)" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
            <xsl:element name="Actie">
              <xsl:value-of select="Actie" />
            </xsl:element>
            <xsl:element name="ActieCode">
              <xsl:value-of select="ActieCode" />
            </xsl:element>
            <xsl:element name="Order_Nr">
              <xsl:value-of select="Order_Nr" />
            </xsl:element>
            <xsl:element name="Taak_Nr">
              <xsl:value-of select="$TaakNr" />
            </xsl:element>
            <xsl:element name="EAN_pallet">
              <xsl:value-of select="EAN_pallet" />
            </xsl:element>
            <xsl:element name="EAN_colli">
              <xsl:value-of select="EAN_colli" />
            </xsl:element>
            <xsl:element name="Productcode">
              <xsl:value-of select="Productcode" />
            </xsl:element>
            <xsl:element name="Redencode">
              <xsl:choose>
                <xsl:when test="Redencode != ''">
                  <xsl:value-of select="Redencode" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>0005</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
            <xsl:element name="Omschrijving">
              <xsl:value-of select="Omschrijving" />
            </xsl:element>
            <xsl:element name="SSCC">
              <xsl:value-of select="SSCC" />
            </xsl:element>
            <xsl:element name="Lotnr">
              <xsl:value-of select="Lotnr" />
            </xsl:element>
            <xsl:element name="THT">
              <xsl:value-of select="MyScript:ParseDateTime(THT,'yyyy-MM-dd','dd/MM/yy')" />
            </xsl:element>
            <xsl:element name="Colli">
              <xsl:value-of select="sum(key('GroupBy-Actie_ActieCode_Productcode_Redencode_SSCC_Lotnr_THT',$LineKey)/Colli)" />
            </xsl:element>
            <xsl:element name="Behandelaar">
              <xsl:value-of select="Behandelaar" />
            </xsl:element>
            <xsl:element name="Datum_creatie">
              <xsl:value-of select="MyScript:ParseDateTime(Datum_creatie,'yyyy-MM-dd','dd/MM/yy')" />
            </xsl:element>
            <xsl:element name="Tijd_creatie">
              <xsl:value-of select="Tijd_creatie" />
            </xsl:element>
          </xsl:element>
        </xsl:if>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			
      public string ParseDateTime(string input, string formatIn, string formatOut)
      {
        if(System.String.IsNullOrEmpty(input)) return input;
        
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        return dateT.ToString(formatOut);
      }
		]]>
  </msxsl:script>
</xsl:stylesheet>
