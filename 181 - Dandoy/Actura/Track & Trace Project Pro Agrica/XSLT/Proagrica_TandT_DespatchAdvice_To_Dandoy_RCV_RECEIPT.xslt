<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var ttdesp MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receivereceipt:v1.00"
                xmlns:ttdesp="http://www.agroconnect.nl/Portals/10/XSDs/TandT_CPP/v2018p01/TandT_CPP_DespatchAdvice_v2018p01"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:key name="Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC" match="//ttdesp:DeliveryLine/ttdesp:PackageProductUnitFirstLevel"
           use="concat(ttdesp:OrderLineReferenceID, '-', ttdesp:ProductUnit/ttdesp:ProductUnitID_GTIN, '-', ttdesp:ProductUnit/ttdesp:BatchID, '-', ttdesp:ProductUnit/ttdesp:ProductionDate)" />
  <xsl:key name="Group-by-OLRefID_GTIN_Batch_ProdDate" match="//ttdesp:DeliveryLine"
           use="concat(ttdesp:OrderLineReferenceID, '-', ttdesp:ProductUnit/ttdesp:ProductUnitID_GTIN, '-', ttdesp:ProductUnit/ttdesp:BatchID, '-', ttdesp:ProductUnit/ttdesp:ProductionDate)" />
  <xsl:template match="ttdesp:MessageHeader">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="ttdesp:MessageID" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:choose>
            <xsl:when test="contains(ttdesp:SendingDateTime, 'Z')">
              <xsl:value-of select="MyScript:ParseDate(ttdesp:SendingDateTime,'yyyy-MM-ddTHH:mm:ssZ','s')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="MyScript:ParseDate(ttdesp:SendingDateTime,'yyyy-MM-ddTHH:mm:ss','s')" />
            </xsl:otherwise>
          </xsl:choose>
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:choose>
            <xsl:when test="ttdesp:Delivery/ttdesp:TradeParty[ttdesp:TradePartyRoleCode = 'OB']/ttdesp:GlobalID != ''">
              <xsl:value-of select="ttdesp:Delivery/ttdesp:TradeParty[ttdesp:TradePartyRoleCode = 'OB']/ttdesp:GlobalID" />
            </xsl:when>
            <xsl:when test="ttdesp:Delivery/ttdesp:TradeParty[ttdesp:TradePartyRoleCode = 'OF']/ttdesp:GlobalID != ''">
              <xsl:value-of select="ttdesp:Delivery/ttdesp:TradeParty[ttdesp:TradePartyRoleCode = 'OF']/ttdesp:GlobalID" />
            </xsl:when>
          </xsl:choose>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>DANDOY</ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Documents>
        <xsl:for-each select="ttdesp:Delivery">
          <ns0:Document>
            <ns0:DocumentDate>
              <xsl:choose>
                <xsl:when test="contains(../ttdesp:SendingDateTime, 'Z')">
                  <xsl:value-of select="MyScript:ParseDate(../ttdesp:SendingDateTime,'yyyy-MM-ddTHH:mm:ssZ','yyyy-MM-dd')" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="MyScript:ParseDate(../ttdesp:SendingDateTime,'yyyy-MM-ddTHH:mm:ss','yyyy-MM-dd')" />
                </xsl:otherwise>
              </xsl:choose>
            </ns0:DocumentDate>
            <ns0:ExternalDocumentNo>
              <xsl:value-of select="//ttdesp:OrderReferenceID" />
            </ns0:ExternalDocumentNo>
            <ns0:ExternalReference>
              <xsl:value-of select="ttdesp:DeliveryID" />
            </ns0:ExternalReference>
            <xsl:if test="ttdesp:DeliveryDateTime != ''">
              <xsl:choose>
                <xsl:when test="contains(ttdesp:DeliveryDateTime, 'Z')">
                  <ns0:DeliveryDate>
                    <xsl:value-of select="MyScript:ParseDate(ttdesp:DeliveryDateTime,'yyyy-MM-ddTHH:mm:ssZ','yyyy-MM-dd')" />
                  </ns0:DeliveryDate>
                  <ns0:DeliveryTime>
                    <xsl:value-of select="MyScript:ParseDate(ttdesp:DeliveryDateTime,'yyyy-MM-ddTHH:mm:ssZ','HH:mm:ss')" />
                  </ns0:DeliveryTime>
                </xsl:when>
                <xsl:otherwise>
                  <ns0:DeliveryDate>
                    <xsl:value-of select="MyScript:ParseDate(ttdesp:DeliveryDateTime,'yyyy-MM-ddTHH:mm:ss','yyyy-MM-dd')" />
                  </ns0:DeliveryDate>
                  <ns0:DeliveryTime>
                    <xsl:value-of select="MyScript:ParseDate(ttdesp:DeliveryDateTime,'yyyy-MM-ddTHH:mm:ss','HH:mm:ss')" />
                  </ns0:DeliveryTime>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>

            <xsl:for-each select="ttdesp:TradeParty[ttdesp:TradePartyRoleCode = 'SF']">
              <ns0:SenderAddress>
                <ns0:Name>
                  <xsl:value-of select="ttdesp:TradePartyName" />
                </ns0:Name>
                <ns0:Address>
                  <xsl:value-of select="ttdesp:StreetNameAndNumber" />
                </ns0:Address>
                <ns0:City>
                  <xsl:value-of select="ttdesp:CityName" />
                </ns0:City>
                <ns0:PostCode>
                  <xsl:value-of select="ttdesp:PostalCodeLocation" />
                </ns0:PostCode>
                <ns0:CountryRegionCode>
                  <xsl:value-of select="ttdesp:CountryCode" />
                </ns0:CountryRegionCode>
                <ns0:Contact>
                  <xsl:value-of select="ttdesp:PersonToContact" />
                </ns0:Contact>
              </ns0:SenderAddress>
            </xsl:for-each>

            <xsl:if test="count(ttdesp:DeliveryLine) &gt; 0">
              <ns0:DocumentLines>
                <xsl:if test="count(ttdesp:DeliveryLine/ttdesp:PackageProductUnitFirstLevel) &gt; 0">
                  <xsl:for-each select="//ttdesp:DeliveryLine/ttdesp:PackageProductUnitFirstLevel[count(. | key('Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC', concat(ttdesp:OrderLineReferenceID, '-', ttdesp:ProductUnit/ttdesp:ProductUnitID_GTIN, '-', ttdesp:ProductUnit/ttdesp:BatchID, '-', ttdesp:ProductUnit/ttdesp:ProductionDate))[1]) = 1]">
                    <xsl:variable name="LineKey" select="concat(ttdesp:OrderLineReferenceID, '-', ttdesp:ProductUnit/ttdesp:ProductUnitID_GTIN, '-', ttdesp:ProductUnit/ttdesp:BatchID, '-', ttdesp:ProductUnit/ttdesp:ProductionDate)" />
                    <xsl:if test="$LineKey != '---'">
                      <ns0:DocumentLine>
                        <ns0:GTIN>
                          <xsl:choose>
                            <xsl:when test="key('Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC',$LineKey)/ttdesp:PackageProductUnitSecondLevel/ttdesp:ProductUnit/ttdesp:ProductUnitID_GTIN != ''">
                              <xsl:value-of select="substring(key('Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC',$LineKey)/ttdesp:PackageProductUnitSecondLevel/ttdesp:ProductUnit/ttdesp:ProductUnitID_GTIN, string-length(key('Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC',$LineKey)/ttdesp:PackageProductUnitSecondLevel/ttdesp:ProductUnit/ttdesp:ProductUnitID_GTIN) - 12)" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="substring(key('Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC',$LineKey)/ttdesp:ProductUnit/ttdesp:ProductUnitID_GTIN, string-length(key('Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC',$LineKey)/ttdesp:ProductUnit/ttdesp:ProductUnitID_GTIN) - 12)" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </ns0:GTIN>
                        <ns0:OrderQuantity>
                          <xsl:choose>
                            <xsl:when test="key('Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC',$LineKey)/ttdesp:PackageProductUnitSecondLevel/ttdesp:Quantity != ''">
                              <xsl:value-of select="sum(key('Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC',$LineKey)/ttdesp:PackageProductUnitSecondLevel/ttdesp:Multiplication)" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="sum(key('Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC',$LineKey)/ttdesp:Quantity)" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </ns0:OrderQuantity>
                        <ns0:ProductionDate>
                          <xsl:choose>
                            <xsl:when test="contains(key('Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC',$LineKey)/ttdesp:ProductUnit/ttdesp:ProductionDate, 'Z')">
                              <xsl:value-of select="MyScript:ParseDate(key('Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC',$LineKey)/ttdesp:ProductUnit/ttdesp:ProductionDate,'yyyy-MM-ddTHH:mm:ssZ','yyyy-MM-dd')" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="MyScript:ParseDate(key('Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC',$LineKey)/ttdesp:ProductUnit/ttdesp:ProductionDate,'s','yyyy-MM-dd')" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </ns0:ProductionDate>
                        <ns0:ExternalBatchNo>
                          <xsl:value-of select="key('Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC',$LineKey)/ttdesp:ProductUnit/ttdesp:BatchID" />
                        </ns0:ExternalBatchNo>
                        <ns0:Attributes>
                          <ns0:Attribute>
                            <ns0:Code>
                              <xsl:text>LINENO</xsl:text>
                            </ns0:Code>
                            <ns0:Value>
                              <xsl:value-of select="key('Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC',$LineKey)/ttdesp:OrderLineReferenceID" />
                            </ns0:Value>
                          </ns0:Attribute>
                        </ns0:Attributes>
                        <ns0:DocumentDetailLines>
                          <xsl:for-each select="key('Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC',$LineKey)/../ttdesp:ProductUnit[ttdesp:ProductUnitName = 'Pallet']">
                            <ns0:DocumentDetailLine>
                              <ns0:CarrierNo>
                                <xsl:value-of select="ttdesp:ProductUnitID_SSCC" />
                              </ns0:CarrierNo>
                              <ns0:OrderQuantity>
                                <xsl:value-of select="../ttdesp:PackageProductUnitFirstLevel[ttdesp:OrderLineReferenceID = key('Group-by-OLRefID_GTIN_Batch_ProdDate_withSSCC',$LineKey)/ttdesp:OrderLineReferenceID]/ttdesp:PackageProductUnitSecondLevel/ttdesp:Multiplication" />
                              </ns0:OrderQuantity>
                            </ns0:DocumentDetailLine>
                          </xsl:for-each>
                        </ns0:DocumentDetailLines>
                      </ns0:DocumentLine>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:if>

                <xsl:for-each select="ttdesp:DeliveryLine[count(ttdesp:PackageProductUnitFirstLevel) = 0]">
                  <ns0:DocumentLine>
                    <ns0:GTIN>
                      <xsl:value-of select="substring(ttdesp:ProductUnit/ttdesp:ProductUnitID_GTIN, string-length(ttdesp:ProductUnit/ttdesp:ProductUnitID_GTIN) - 12)" />
                    </ns0:GTIN>
                    <ns0:OrderQuantity>
                      <xsl:value-of select="ttdesp:DeliveryLineQuantity" />
                    </ns0:OrderQuantity>
                    <ns0:ProductionDate>
                      <xsl:choose>
                        <xsl:when test="contains(ttdesp:ProductUnit/ttdesp:ProductionDate, 'Z')">
                          <xsl:value-of select="MyScript:ParseDate(ttdesp:ProductUnit/ttdesp:ProductionDate,'yyyy-MM-ddTHH:mm:ssZ','yyyy-MM-dd')" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="MyScript:ParseDate(ttdesp:ProductUnit/ttdesp:ProductionDate,'s','yyyy-MM-dd')" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </ns0:ProductionDate>
                    <!--<ns0:ExpirationDate>
                      <xsl:choose>
                        <xsl:when test="contains(ttdesp:ProductUnit/ttdesp:ProductionDate, 'Z')">
                          <xsl:value-of select="MyScript:ParseDate(ttdesp:ProductUnit/ttdesp:ExpiryDate,'yyyy-MM-ddTHH:mm:ssZ','yyyy-MM-dd')" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="MyScript:ParseDate(ttdesp:ProductUnit/ttdesp:ExpiryDate,'s','yyyy-MM-dd')" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </ns0:ExpirationDate>-->
                    <ns0:ExternalBatchNo>
                      <xsl:value-of select="ttdesp:ProductUnit/ttdesp:BatchID" />
                    </ns0:ExternalBatchNo>
                    <ns0:Attributes>
                      <ns0:Attribute>
                        <ns0:Code>
                          <xsl:text>LINENO</xsl:text>
                        </ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="ttdesp:OrderLineReferenceID" />
                        </ns0:Value>
                      </ns0:Attribute>
                    </ns0:Attributes>
                  </ns0:DocumentLine>
                </xsl:for-each>
              </ns0:DocumentLines>
            </xsl:if>

          </ns0:Document>
        </xsl:for-each>
      </ns0:Documents>
    </ns0:Message>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			

      public int LINCounter = 0;
      public string GetLinCounter()
      {
          LINCounter = LINCounter + 1;
          return LINCounter.ToString();
      }   
      
			public string GetCurrentDate(string formatOut)
			{
				return System.DateTime.Now.ToString(formatOut);
			}
      
      public string ParseEOMDate(string input, string formatIn, string formatOut)
      {
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        DateTime endOfMonth = new DateTime(dateT.Year, dateT.Month, DateTime.DaysInMonth(dateT.Year, dateT.Month));
        return endOfMonth.ToString(formatOut);
      }
      
      public string ParseDate(string input, string formatIn, string formatOut)
      {
        if(System.String.IsNullOrEmpty(input)) return input;
        
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        return dateT.ToString(formatOut);
      }
      
      public string GetGUID()
      {
        return "{"+Guid.NewGuid().ToString()+"}";
      }            

		]]>
  </msxsl:script>
</xsl:stylesheet>