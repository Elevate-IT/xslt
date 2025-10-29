<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ttdesp="http://www.agroconnect.nl/Portals/10/XSDs/TandT_CPP/v2018p01/TandT_CPP_DespatchAdvice_v2018p01"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:s0="www.boltrics.nl/sendshipment:v1.00"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
    exclude-result-prefixes="msxsl MyScript s0"
>
  <xsl:output omit-xml-declaration="no" method="xml" version="1.0" />
  
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
  </xsl:template>
  
  <xsl:template match="//s0:Message/s0:Documents/s0:Document">
    <ttdesp:MessageHeader xsi:schemaLocation="http://www.agroconnect.nl/Portals/10/XSDs/TandT_CPP/v2018p01/TandT_CPP_DespatchAdvice_v2018p01 http://www.agroconnect.nl/Portals/10/XSDs/TandT_CPP/v2018p01/TandT_CPP_DespatchAdvice_v2018p01.xsd">
      <ttdesp:MessageID schemeID="REF">
        <xsl:value-of select="//s0:MessageID" />
      </ttdesp:MessageID>
      <ttdesp:SendingDateTime>
        <xsl:value-of select="//s0:CreationDateTime" />
      </ttdesp:SendingDateTime>
      <ttdesp:SendingPartyID schemeID="GLN">
        <xsl:text>5488888010642</xsl:text>
      </ttdesp:SendingPartyID>
      <ttdesp:ReceivingPartyID schemeID="GLN">
        <xsl:value-of select="//s0:ToTradingPartner" />
      </ttdesp:ReceivingPartyID>
      <ttdesp:MessageType>102</ttdesp:MessageType>
      <ttdesp:MessagePurposeCode>47</ttdesp:MessagePurposeCode>
      
      <ttdesp:Delivery>
        <ttdesp:DeliveryID schemeID="REF">
          <xsl:value-of select="s0:ExternalDocumentNo" />
        </ttdesp:DeliveryID>
        <ttdesp:DeliveryStatusCode>101</ttdesp:DeliveryStatusCode>
        <!--101= original-->
        <ttdesp:DeliveryDateTime>
          <xsl:value-of select="//s0:CreationDateTime" />
        </ttdesp:DeliveryDateTime>
        <xsl:if test="s0:GrossWeight != 0">
          <ttdesp:GrossWeight unitCode="KGM">
            <xsl:value-of select="s0:GrossWeight" />
          </ttdesp:GrossWeight>
        </xsl:if>
        <xsl:if test="s0:NetWeight != 0">
          <ttdesp:NetWeight unitCode="KGM">
            <xsl:value-of select="s0:NetWeight" />
          </ttdesp:NetWeight>
        </xsl:if>
        
        <ttdesp:Timing>
          <ttdesp:EventTypeCode>101</ttdesp:EventTypeCode>
          <!-- = Load-->
          <ttdesp:EventDateTime>
            <xsl:value-of select="MyScript:ParseDate(s0:PostingDate, 'yyyy-MM-dd', 's')" />
          </ttdesp:EventDateTime>
        </ttdesp:Timing>
        <ttdesp:Timing>
          <ttdesp:EventTypeCode>102</ttdesp:EventTypeCode>
          <!-- = Deliver-->
          <ttdesp:EventDateTime>
            <xsl:value-of select="MyScript:ParseDate(s0:DeliveryDate, 'yyyy-MM-dd', 's')" />
          </ttdesp:EventDateTime>
        </ttdesp:Timing>
        
        <!--<ttdesp:MeansOfTransportation>
          <ttdesp:TransportMeansID schemeID="NUMMERPLAAT">
            <xsl:value-of select="s0:VehicleNo" />
          </ttdesp:TransportMeansID>
          <ttdesp:TransportMeansTypeCode>36</ttdesp:TransportMeansTypeCode>
          -->
        <!-- = Truck, dry bulk-->
        <!--
        </ttdesp:MeansOfTransportation>-->
        <!--<ttdesp:InternationalCommercialTerms>
          <ttdesp:ICT_ReferenceID>Ref EU2356</ttdesp:ICT_ReferenceID>
          <ttdesp:ICT_Description>Volgens Europese regelgeving.</ttdesp:ICT_Description>
        </ttdesp:InternationalCommercialTerms>-->
        
        <xsl:if test="s0:SenderAddress/s0:No != ''">
          <ttdesp:TradeParty>
            <ttdesp:GlobalID>
              <xsl:value-of select="s0:SenderAddress/s0:No" />
            </ttdesp:GlobalID>
            <ttdesp:TradePartyRoleCode>SF</ttdesp:TradePartyRoleCode>
            <!--= ShippedFrom-->
            <ttdesp:TradePartyName>
              <xsl:value-of select="s0:SenderAddress/s0:Name" />
            </ttdesp:TradePartyName>
            <ttdesp:StreetNameAndNumber>
              <xsl:value-of select="s0:SenderAddress/s0:Address" />
            </ttdesp:StreetNameAndNumber>
            <ttdesp:PostalCodeLocation>
              <xsl:value-of select="s0:SenderAddress/s0:PostCode" />
            </ttdesp:PostalCodeLocation>
            <ttdesp:CityName>
              <xsl:value-of select="s0:SenderAddress/s0:City" />
            </ttdesp:CityName>
            <ttdesp:CountryCode>
              <xsl:value-of select="s0:SenderAddress/s0:CountryRegionCode" />
            </ttdesp:CountryCode>
            <!--<ttdesp:PersonToContact>Floris Rhemrev</ttdesp:PersonToContact>-->
          </ttdesp:TradeParty>
        </xsl:if>
        
        <ttdesp:TradeParty>
          <ttdesp:GlobalID>
            <xsl:value-of select="s0:ShipToAddress/s0:No" />
          </ttdesp:GlobalID>
          <ttdesp:TradePartyRoleCode>ST</ttdesp:TradePartyRoleCode>
          <!--= ShippedTo-->
          <ttdesp:TradePartyName>
            <xsl:value-of select="s0:ShipToAddress/s0:Name" />
          </ttdesp:TradePartyName>
          <ttdesp:StreetNameAndNumber>
            <xsl:value-of select="s0:ShipToAddress/s0:Address" />
          </ttdesp:StreetNameAndNumber>
          <ttdesp:PostalCodeLocation>
            <xsl:value-of select="s0:ShipToAddress/s0:PostCode" />
          </ttdesp:PostalCodeLocation>
          <ttdesp:CityName>
            <xsl:value-of select="s0:ShipToAddress/s0:City" />
          </ttdesp:CityName>
          <ttdesp:CountryCode>
            <xsl:value-of select="s0:ShipToAddress/s0:CountryRegionCode" />
          </ttdesp:CountryCode>
        </ttdesp:TradeParty>
        
        <xsl:for-each select="s0:DocumentLines/s0:DocumentLine/s0:DocumentDetailLines/s0:DocumentDetailLine[s0:Posted = '1']">
            <ttdesp:DeliveryLine>
              <ttdesp:DeliveryLineID schemeID="REF">
                <xsl:choose>
                  <xsl:when test="../../s0:Attributes/s0:Attribute[s0:Code='LINENO']/s0:Value != ''">
                    <xsl:value-of select="../../s0:Attributes/s0:Attribute[s0:Code='LINENO']/s0:Value" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="s0:DocumentLineNo" />
                  </xsl:otherwise>
                </xsl:choose>
              </ttdesp:DeliveryLineID>
              <ttdesp:DeliveryLineQuantity unitCode="NBR">
                <xsl:value-of select="s0:OrderQuantity" />
              </ttdesp:DeliveryLineQuantity>
              <ttdesp:OrderReferenceID schemeID="REF">
                <xsl:value-of select="//s0:ExternalReference" />
              </ttdesp:OrderReferenceID>
              <ttdesp:OrderLineReferenceID schemeID="REF">
                <xsl:choose>
                  <xsl:when test="../../s0:Attributes/s0:Attribute[s0:Code='LINENO']/s0:Value != ''">
                    <xsl:value-of select="../../s0:Attributes/s0:Attribute[s0:Code='LINENO']/s0:Value" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="s0:DocumentLineNo" />
                  </xsl:otherwise>
                </xsl:choose>
              </ttdesp:OrderLineReferenceID>
              
              <ttdesp:ProductUnit>
                <ttdesp:ProductUnitID_SSCC schemeID="SSCC">
                  <xsl:value-of select="s0:CarrierNo" />
                </ttdesp:ProductUnitID_SSCC>
                <ttdesp:ProductUnitID_GTIN schemeID="GTIN">
                  <xsl:choose>
                    <xsl:when test="../../s0:Attributes/s0:Attribute[s0:Code = 'GTIN']/s0:Value != ''">
                      <xsl:value-of select="../../s0:Attributes/s0:Attribute[s0:Code = 'GTIN']/s0:Value" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="../../s0:EANCode != ''">
                          <xsl:value-of select="../../s0:EANCode" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="../../s0:ExternalNo" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </ttdesp:ProductUnitID_GTIN>
                <ttdesp:ProductUnitTypeCode>101</ttdesp:ProductUnitTypeCode>
                <!-- = LogisticUnit-->
                <ttdesp:BatchID>
                  <xsl:value-of select="s0:ExternalBatchNo" />
                </ttdesp:BatchID>
                <ttdesp:ProductUnitName>
                  <xsl:value-of select="../../s0:Description" />
                </ttdesp:ProductUnitName>
              </ttdesp:ProductUnit>
            </ttdesp:DeliveryLine>
        </xsl:for-each>
        
      </ttdesp:Delivery>
    </ttdesp:MessageHeader>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			
      public string ParseDate(string input, string formatIn, string formatOut)
      {
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        return dateT.ToString(formatOut);
      }
      
      public string GetCurrentDate(string formatOut)
			{
				return System.DateTime.Now.ToString(formatOut);
			}
		]]>
  </msxsl:script>
</xsl:stylesheet>