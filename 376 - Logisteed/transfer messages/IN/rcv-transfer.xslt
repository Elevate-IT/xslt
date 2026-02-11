<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript" version="3.0"
                xmlns:ns0="www.boltrics.nl/receivetransfer:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:template match="/">
    
    <!-- First physical business line -->
    <xsl:variable name="docLine"
      select="(//MessageLines/Lines/Line)[1]"/>
    
    <!-- All real document lines EXCEPT the empty last one -->
    <xsl:variable name="lineNodes"
      select="//MessageLines/Lines/Line[normalize-space() != '']"/>
    
    
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="generate-id()" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="current-dateTime()" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:text>JCHEU</xsl:text>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:text>LOGISTEED</xsl:text>
        </ns0:ToTradingPartner>
        <ns0:Information>
          <xsl:text>RCV-TRANSFER</xsl:text>
        </ns0:Information>
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="normalize-space(substring($docLine, 21, 20))"/>
          </ns0:ExternalDocumentNo>
          
          <ns0:ExternalReference>
            <xsl:value-of select="normalize-space(substring($docLine, 41, 20))"/>
          </ns0:ExternalReference>
          
          <ns0:OrderDate>
            <xsl:value-of select="normalize-space(substring($docLine, 61, 8))"/>
          </ns0:OrderDate> 
          
          <ns0:DocumentDate>
            <xsl:value-of select="normalize-space(substring($docLine, 69, 8))"/>
          </ns0:DocumentDate> 
          
          <ns0:DeliveryDate>
            <xsl:value-of select="normalize-space(substring($docLine, 77, 8))"/>
          </ns0:DeliveryDate> 
          
          <!-- <ns0:>
               <xsl:value-of select="normalize-space(substring($docLine, 85, 10))"/>
               </ns0:> -->
          
          <ns0:IncoTermCode>
            <xsl:value-of select="normalize-space(substring($docLine, 95, 3))"/>
          </ns0:IncoTermCode> 
          
          <ns0:IncoTermCity>
            <xsl:value-of select="normalize-space(substring($docLine, 98, 25))"/>
          </ns0:IncoTermCity> 
          
          <ns0:ConsigneeAddress>
            <ns0:ExternalNo>
              <xsl:value-of select="normalize-space(substring($docLine, 143, 20))"/>
            </ns0:ExternalNo>
          </ns0:ConsigneeAddress>
          
          <ns0:ShipToAddress>
            <ns0:ExternalNo>
              <xsl:value-of select="normalize-space(substring($docLine, 420, 20))"/>
            </ns0:ExternalNo>
          </ns0:ShipToAddress>
          
          <ns0:CustomsCode>
            <xsl:value-of select="normalize-space(substring($docLine, 752, 1))"/>
          </ns0:CustomsCode>   
          
          <ns0:DocumentLines>
            <xsl:for-each select="$lineNodes">
              <ns0:DocumentLine>
                
                <!-- <TEST>
                     <xsl:value-of select="."/>
                     </TEST> -->
                
                <ns0:ExternalNo>
                  <xsl:value-of select="normalize-space(substring(., 1367, 18))"/>
                </ns0:ExternalNo>
                
                <ns0:Description>
                  <xsl:value-of select="normalize-space(substring(., 1385, 40))"/>
                </ns0:Description>
                
                <ns0:Quantity>
                  <xsl:value-of select="normalize-space(substring(., 1426, 9))"/>
                </ns0:Quantity>
                
                <ns0:UnitOfMeasureCode>
                  <xsl:text>PCE</xsl:text>
                </ns0:UnitOfMeasureCode>
                
                <ns0:CurrencyCode>
                  <xsl:value-of select="normalize-space(substring(., 1521, 3))"/>
                </ns0:CurrencyCode>
                
                <ns0:Attributes>
                  <ns0:Attribute>
                    <ns0:Code>EDILINENO</ns0:Code>
                    <ns0:Value>
                      <xsl:value-of select="normalize-space(substring(., 1363, 4))"/>
                    </ns0:Value>
                  </ns0:Attribute>
                </ns0:Attributes>
                
              </ns0:DocumentLine>
            </xsl:for-each>
          </ns0:DocumentLines> 
        </ns0:Document>
      </ns0:Documents>
    </ns0:Message>
  </xsl:template>
</xsl:stylesheet>
