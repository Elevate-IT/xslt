<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var" 
                exclude-result-prefixes="msxsl var s0 MyScript" 
                xmlns:ns0="www.boltrics.nl/receivereceiptwolf:v1.00" 
                xmlns:s0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006" 
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema" version="3.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  
  <xsl:template match="xml">
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
          <xsl:text>20438</xsl:text>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:text>Mervielde</xsl:text>
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="document_number" />
          </ns0:ExternalDocumentNo>
          
          <ns0:DocumentLines>
            <xsl:for-each select="order_lines/product">
              <ns0:DocumentLine>
                <ns0:ExternalNo>
                  <xsl:value-of select="parent_product" />
                </ns0:ExternalNo>
                <ns0:Description>
                  <xsl:value-of select="product_name" />
                </ns0:Description>
                <ns0:OrderQuantity>
                  <xsl:value-of select="quantity_liters" />
                </ns0:OrderQuantity>
                <ns0:OrderUnitofMeasureCode>
                  <xsl:value-of select="customer_unit" />
                </ns0:OrderUnitofMeasureCode>
                <ns0:GrossWeight>
                  <xsl:value-of select="quantity_kg" />
                </ns0:GrossWeight>

                <ns0:Attributes>
                  <ns0:Attribute>
                    <ns0:Code>WOLFMSGID</ns0:Code>
                    <ns0:Value>
                      <xsl:value-of select="//message_id" />
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
