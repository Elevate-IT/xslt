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
          <ns0:OrderTypeCode>
            <xsl:text>INTERNALTRANSFER</xsl:text>
          </ns0:OrderTypeCode>
          
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="normalize-space(substring($docLine, 21, 20))"/>
          </ns0:ExternalDocumentNo>
          
          <ns0:ShipToAddress>
            <ns0:ExternalNo>
              <xsl:value-of select="normalize-space(substring($docLine, 41, 20))"/>
            </ns0:ExternalNo>
          </ns0:ShipToAddress>
          
          <ns0:Attribute03>
            <xsl:value-of select="normalize-space(substring($docLine, 41, 20))"/>
          </ns0:Attribute03>
          
          <ns0:PostingDate>
            <xsl:value-of select="normalize-space(substring($docLine, 61, 8))"/>
          </ns0:PostingDate> 
          
          <ns0:OrderDate>
            <xsl:value-of select="normalize-space(substring($docLine, 69, 8))"/>
          </ns0:OrderDate> 
          
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
          
          <ns0:ShippingAgentCode>
            <xsl:text>INTERN</xsl:text>
          </ns0:ShippingAgentCode>
          
          <ns0:SenderAddress>
            <ns0:ExternalNo>
              <xsl:value-of select="normalize-space(substring($docLine, 143, 20))"/>
            </ns0:ExternalNo>
          </ns0:SenderAddress>
          
          <!-- <ns0:ShipToAddress>
               <ns0:ExternalNo>
               <xsl:value-of select="normalize-space(substring($docLine, 420, 20))"/>
               </ns0:ExternalNo>
               </ns0:ShipToAddress> -->
          
          <!-- <ns0:CustomsCode>
               <xsl:value-of select="normalize-space(substring($docLine, 752, 1))"/>
               </ns0:CustomsCode>    -->
          
          <xsl:if test="normalize-space(substring($docLine, 773, 560)) != ''">
            <ns0:Attributes>
              
              <!-- WareHouse instructions -->
              
              <xsl:if test="normalize-space(substring($docLine, 773, 70)) != ''">
                <ns0:Attribute>
                  <ns0:Code>WHINSTR1</ns0:Code>
                  <ns0:Value>normalize-space(substring($docLine, 773, 70))</ns0:Value>
                </ns0:Attribute>
              </xsl:if> 
              
              <xsl:if test="normalize-space(substring($docLine, 843, 70)) != ''">
                <ns0:Attribute>
                  <ns0:Code>WHINSTR2</ns0:Code>
                  <ns0:Value>normalize-space(substring($docLine, 843, 70))</ns0:Value>
                </ns0:Attribute>
              </xsl:if> 
              
              <xsl:if test="normalize-space(substring($docLine, 913, 70)) != ''">
                <ns0:Attribute>
                  <ns0:Code>WHINSTR3</ns0:Code>
                  <ns0:Value>normalize-space(substring($docLine, 913, 70))</ns0:Value>
                </ns0:Attribute>
              </xsl:if> 
              
              <xsl:if test="normalize-space(substring($docLine, 983, 70)) != ''">
                <ns0:Attribute>
                  <ns0:Code>WHINSTR4</ns0:Code>
                  <ns0:Value>normalize-space(substring($docLine, 983, 70))</ns0:Value>
                </ns0:Attribute>
              </xsl:if> 
              
              <!-- Delivery instructions -->
              
              <xsl:if test="normalize-space(substring($docLine, 1053, 70)) != ''">
                <ns0:Attribute>
                  <ns0:Code>DELINSTR1</ns0:Code>
                  <ns0:Value>normalize-space(substring($docLine, 1053, 70))</ns0:Value>
                </ns0:Attribute>
              </xsl:if> 
              
              <xsl:if test="normalize-space(substring($docLine, 1123, 70)) != ''">
                <ns0:Attribute>
                  <ns0:Code>DELINSTR2</ns0:Code>
                  <ns0:Value>normalize-space(substring($docLine, 1123, 70))</ns0:Value>
                </ns0:Attribute>
              </xsl:if> 
              
              <xsl:if test="normalize-space(substring($docLine, 1193, 70)) != ''">
                <ns0:Attribute>
                  <ns0:Code>DELINSTR3</ns0:Code>
                  <ns0:Value>normalize-space(substring($docLine, 1193, 70))</ns0:Value>
                </ns0:Attribute>
              </xsl:if> 
              
              <xsl:if test="normalize-space(substring($docLine, 1263, 70)) != ''">
                <ns0:Attribute>
                  <ns0:Code>DELINSTR4</ns0:Code>
                  <ns0:Value>normalize-space(substring($docLine, 1263, 70))</ns0:Value>
                </ns0:Attribute>
              </xsl:if> 
              
            </ns0:Attributes>
          </xsl:if>    
          
          
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
                
                <!-- Attributes -->
                
                <!-- <ns0:UnitPrice>
                  <xsl:value-of select="normalize-space(substring(., 1509, 12))"/>
                </ns0:UnitPrice> -->
                
                <ns0:CurrencyCode>
                  <xsl:value-of select="normalize-space(substring(., 1521, 3))"/>
                </ns0:CurrencyCode>
                
                <!-- <ns0:Attribute01>
                     <xsl:value-of select="normalize-space(substring(., 1499, 10))"/>
                     </ns0:Attribute01> -->
                
                <ns0:Attribute01>
                  <xsl:variable name="cleanValue" select="normalize-space(substring(., 1499, 10))" />
                  
                  <xsl:choose>
                    <xsl:when test="$cleanValue = 'normal'">AVAILABLE</xsl:when>
                    <!-- <xsl:when test="$cleanValue = '10'">OUT OF WARRANTY</xsl:when>
                         <xsl:when test="$cleanValue = '11'">GRADED STOCK</xsl:when>
                         <xsl:when test="$cleanValue = '12'">GOOD STOCK TBC</xsl:when>
                         <xsl:when test="$cleanValue = '15'">NON-ROHS</xsl:when>
                         <xsl:when test="$cleanValue = '2'">OLD SPECS</xsl:when>
                         <xsl:when test="$cleanValue = '20'">DAMAGED CARTONS</xsl:when>
                         <xsl:when test="$cleanValue = '30'">DAMAGED</xsl:when>
                         <xsl:when test="$cleanValue = '35'">INSURANCE STOCK</xsl:when>
                         <xsl:when test="$cleanValue = '40'">EXHIBITION STOCK</xsl:when>
                         <xsl:when test="$cleanValue = '50'">RE-WORK (HACE)</xsl:when>
                         <xsl:when test="$cleanValue = '60'">SERVICE (HACE)</xsl:when>
                         <xsl:when test="$cleanValue = 'NA'">SHORTAGE</xsl:when>
                         <xsl:when test="$cleanValue = 'S&amp;E'">JCI SOUTH AND EXPORT</xsl:when> -->
                    <xsl:otherwise>
                      <xsl:value-of select="$cleanValue"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </ns0:Attribute01>
                
                <ns0:Attributes>
                  <ns0:Attribute>
                    <ns0:Code>EDILINENO</ns0:Code>
                    <ns0:Value>
                      <xsl:value-of select="normalize-space(substring(., 1363, 4))"/>
                    </ns0:Value>
                  </ns0:Attribute>
                  
                  <xsl:if test="normalize-space(substring($docLine, 1439, 20)) != ''">
                    <ns0:Attribute>
                      <ns0:Code>LINEREF</ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="normalize-space(substring(., 1439, 20))"/>
                      </ns0:Value>
                    </ns0:Attribute>
                  </xsl:if> 
                  
                  <xsl:if test="normalize-space(substring($docLine, 1459, 20)) != ''">
                    <ns0:Attribute>
                      <ns0:Code>EDI_REF</ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="normalize-space(substring(., 1459, 20))"/>
                      </ns0:Value>
                    </ns0:Attribute>
                  </xsl:if> 
                  
                </ns0:Attributes>
              </ns0:DocumentLine>
            </xsl:for-each>
          </ns0:DocumentLines> 
        </ns0:Document>
      </ns0:Documents>
    </ns0:Message>
  </xsl:template>
</xsl:stylesheet>
