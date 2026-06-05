<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var s0 xs" version="3.0"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
               >
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:variable name="doc" select="/" ></xsl:variable>
  <xsl:template match="//s0:EFACT_D01B_DESADV">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="UNH/UNH1" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
        <xsl:value-of select= "format-date(xs:date(concat(
  substring(s0:DTM/s0:C507[C50701='137']/C50702,1,4),'-',
  substring(s0:DTM/s0:C507[C50701='137']/C50702,5,2),'-',
  substring(s0:DTM/s0:C507[C50701='137']/C50702,7,2))),'[Y0001]-[M01]-[D01]')"/>
        </ns0:CreationDateTime>
        <ns0:ProcesAction>  
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01='SU']/s0:C082/C08201" />
        </ns0:FromTradingPartner>
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <ns0:DocumentDate>
           <xsl:value-of select="format-date(xs:date(concat(
  substring(s0:DTM/s0:C507[C50701='137']/C50702,1,4),'-',
  substring(s0:DTM/s0:C507[C50701='137']/C50702,5,2),'-',
  substring(s0:DTM/s0:C507[C50701='137']/C50702,7,2))),'[Y0001]-[M01]-[D01]')"/>
          </ns0:DocumentDate>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="s0:BGM/s0:C106/C10601" />
          </ns0:ExternalDocumentNo>
          <xsl:if test="s0:RFFLoop1/s0:RFF/s0:C506[C50601='ON']/C50602 != ''">
            <ns0:ExternalReference>
              <xsl:value-of select="s0:RFFLoop1/s0:RFF/s0:C506[C50601='ON']/C50602" />
            </ns0:ExternalReference>
          </xsl:if>
          <ns0:DeliveryDate>
          <xsl:value-of select="format-date(xs:date(concat(
  substring(s0:DTM/s0:C507[C50701='17']/C50702,1,4),'-',
  substring(s0:DTM/s0:C507[C50701='17']/C50702,5,2),'-',
  substring(s0:DTM/s0:C507[C50701='17']/C50702,7,2))),'[Y0001]-[M01]-[D01]')"/>
          </ns0:DeliveryDate>
          <ns0:ShipToAddress>
            <ns0:ExternalNo>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C082/C08201" />
            </ns0:ExternalNo>
            <ns0:Name>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C080/C08001" />
            </ns0:Name>
            <ns0:Address>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C059/C05901" />
            </ns0:Address>
            <ns0:Address2>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'DP']/s0:C059/C05902"/>
            </ns0:Address2>
            <ns0:City>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'DP']/NAD06" />
            </ns0:City>
            <ns0:PostCode>
              <xsl:value-of select="normalize-space(s0:NADLoop1/s0:NAD[NAD01 = 'DP']/NAD08)" />
            </ns0:PostCode>
            <ns0:CountryCode>
              <xsl:value-of select="s0:NADLoop1/s0:NAD[NAD01 = 'DP']/NAD09" />
            </ns0:CountryCode>
          </ns0:ShipToAddress>
          <ns0:DocumentComments>
            <xsl:for-each select="s0:FTX[FTX01 = 'AAI']">
              <ns0:DocumentComment>
                <ns0:Code>
                  <xsl:value-of select="s0:C108/C10801" />
                </ns0:Code>
              </ns0:DocumentComment>
            </xsl:for-each>          
          </ns0:DocumentComments>
          <ns0:Attributes>
            <ns0:Attribute>
            </ns0:Attribute>
          </ns0:Attributes>

          <xsl:if test="count(//s0:LINLoop1)&gt;0">
            <ns0:DocumentLines>
              <xsl:for-each select="//s0:LINLoop1">
                
                  <ns0:DocumentLine>
                    <ns0:ExternalNo>
                      <xsl:value-of select="s0:PIA/s0:C212_2/C21201"/>
                    </ns0:ExternalNo>
                    <ns0:Description>
                      <xsl:value-of select="s0:IMD/s0:C273/C27304"/>
                    </ns0:Description>
                    <ns0:OrderQuantity>
                      <xsl:value-of select="s0:QTY_3/s0:C186_3/C18602" />
                    </ns0:OrderQuantity>
                    <ns0:Attributes>
                      <ns0:Attribute>
                        <ns0:Code>LINENO</ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="s0:LIN/LIN01" />
                        </ns0:Value>
                      </ns0:Attribute>
                    </ns0:Attributes>
                  </ns0:DocumentLine>
              </xsl:for-each>
            </ns0:DocumentLines>
          </xsl:if>

        </ns0:Document>
      </ns0:Documents>
    </ns0:Message>
  </xsl:template>
  
</xsl:stylesheet>