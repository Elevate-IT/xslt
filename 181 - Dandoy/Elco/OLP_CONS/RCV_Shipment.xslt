<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="msxsl MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="//EDI_DC40">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="MyScript:GetGUID()" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="MyScript:GetCurrentDate('s')" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>ELCO1070K</ns0:FromTradingPartner>
        <ns0:ToTradingPartner>5314626200000</ns0:ToTradingPartner>
        <ns0:Information>RCV-SHIPMENT</ns0:Information>
      </ns0:Header>
      <ns0:Documents>
        <ns0:Document>
          <ns0:DocumentDate>
            <xsl:value-of select="MyScript:GetCurrentDate('yyyy-MM-dd')" />
          </ns0:DocumentDate>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="E2EDL20/vbeln" />
          </ns0:ExternalDocumentNo>
          <ns0:ExternalReference>
            <!--PO Number-->
            <xsl:value-of select="E2EDL20/E2EDL24/E2EDL41/bstnr"/>
          </ns0:ExternalReference>
          <AdditionalDocumentNo>
            <!--ATG Number-->
            <xsl:value-of select="E2EDL20/E2EDL24/E2EDL43/belnr"/>
          </AdditionalDocumentNo>
          <ns0:PlannedStartDate>
            <xsl:value-of select="MyScript:ParseDate(E2EDL20/E2EDT13001[qualf='010']/ntanf,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:PlannedStartDate>
          <ns0:DeliveryDate>
            <xsl:value-of select="MyScript:ParseDate(E2EDL20/E2EDT13001[qualf='007']/ntanf,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:DeliveryDate>
          <ns0:DepartedDate>
            <xsl:value-of select="MyScript:ParseDate(E2EDL20/E2EDT13001[qualf='006']/ntanf,'yyyyMMdd','yyyy-MM-dd')" />
          </ns0:DepartedDate>
          <ns0:SenderReference>
            <xsl:value-of select="rcvprn" />
          </ns0:SenderReference>
          <ns0:SenderAddress>
            <xsl:choose>
              <xsl:when test="E2EDL20/E2EDL21/lfart = 'ZLF'">
                <!--<ns0:ExternalNo>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='OSP']/partner_id"/>
                </ns0:ExternalNo>-->
                <ns0:Name>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='OSP']/name1"/>
                </ns0:Name>
                <ns0:Name2>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='OSP']/name2"/>
                </ns0:Name2>
                <ns0:Address>
                  <xsl:value-of select="concat(E2EDL20/E2ADRM1001[partner_q='OSP']/street1, ' ' , E2EDL20/E2ADRM1001[partner_q='OSP']/house_supl)"/>
                </ns0:Address>
                <ns0:City>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='OSP']/city1"/>
                </ns0:City>
                <ns0:PostCode>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='OSP']/postl_cod1"/>
                </ns0:PostCode>
                <ns0:CountryCode>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='OSP']/country1"/>
                </ns0:CountryCode>
              </xsl:when>
              <xsl:when test="E2EDL20/E2EDL21/lfart = 'ZLR'">
                <!--<ns0:ExternalNo>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='WE']/partner_id"/>
                </ns0:ExternalNo>-->
                <ns0:Name>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='WE']/name1"/>
                </ns0:Name>
                <ns0:Name2>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='WE']/name2"/>
                </ns0:Name2>
                <ns0:Address>
                  <xsl:value-of select="concat(E2EDL20/E2ADRM1001[partner_q='WE']/street1, ' ' , E2EDL20/E2ADRM1001[partner_q='WE']/house_supl)"/>
                </ns0:Address>
                <ns0:City>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='WE']/city1"/>
                </ns0:City>
                <ns0:PostCode>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='WE']/postl_cod1"/>
                </ns0:PostCode>
                <ns0:CountryCode>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='WE']/country1"/>
                </ns0:CountryCode>
              </xsl:when>
            </xsl:choose>
          </ns0:SenderAddress>
          <ns0:ShipToAddress>
            <xsl:choose>
              <xsl:when test="E2EDL20/E2EDL21/lfart = 'ZLF'">
                <!--<ns0:ExternalNo>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='WE']/partner_id"/>
                </ns0:ExternalNo>-->
                <ns0:Name>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='WE']/name1"/>
                </ns0:Name>
                <ns0:Name2>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='WE']/name2"/>
                </ns0:Name2>
                <ns0:Address>
                  <xsl:value-of select="concat(E2EDL20/E2ADRM1001[partner_q='WE']/street1, ' ' , E2EDL20/E2ADRM1001[partner_q='WE']/house_supl)"/>
                </ns0:Address>
                <ns0:City>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='WE']/city1"/>
                </ns0:City>
                <ns0:PostCode>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='WE']/postl_cod1"/>
                </ns0:PostCode>
                <ns0:CountryCode>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='WE']/country1"/>
                </ns0:CountryCode>
              </xsl:when>
              <xsl:when test="E2EDL20/E2EDL21/lfart = 'ZLR'">
                <!--<ns0:ExternalNo>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='OSP']/partner_id"/>
                </ns0:ExternalNo>-->
                <ns0:Name>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='OSP']/name1"/>
                </ns0:Name>
                <ns0:Name2>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='OSP']/name2"/>
                </ns0:Name2>
                <ns0:Address>
                  <xsl:value-of select="concat(E2EDL20/E2ADRM1001[partner_q='OSP']/street1, ' ' , E2EDL20/E2ADRM1001[partner_q='OSP']/house_supl)"/>
                </ns0:Address>
                <ns0:City>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='OSP']/city1"/>
                </ns0:City>
                <ns0:PostCode>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='OSP']/postl_cod1"/>
                </ns0:PostCode>
                <ns0:CountryCode>
                  <xsl:value-of select="E2EDL20/E2ADRM1001[partner_q='OSP']/country1"/>
                </ns0:CountryCode>
              </xsl:when>
            </xsl:choose>
          </ns0:ShipToAddress>
          <xsl:if test="E2EDL20/inco1 = 'DDP'">
            <!--NA TE VRAGEN-->
            <ns0:CarrierAddress>
              <ns0:No>ADR00001</ns0:No>
            </ns0:CarrierAddress>
          </xsl:if>
          <ns0:SequenceNo>
            <xsl:value-of select="E2EDL20/E2EDL21/lprio"/>
          </ns0:SequenceNo>
          <!--<ns0:Attributes>
            <ns0:Attribute>
              <ns0:Code>SHIPAGENT</ns0:Code>
              <ns0:Value>
                <xsl:value-of select="ShippingAgentCode" />
              </ns0:Value>
            </ns0:Attribute>
          </ns0:Attributes>-->

          <xsl:if test="count(//E2EDL24)&gt;0">
            <ns0:DocumentLines>
              <xsl:for-each select="//E2EDL24">
                <ns0:DocumentLine>
                  <ns0:ExternalNo>
                    <xsl:value-of select="matnr"/>
                  </ns0:ExternalNo>
                  <ns0:Description>
                    <xsl:value-of select="arktx"/>
                  </ns0:Description>
                  <xsl:if test="vrkme = 'PCE'">
                    <ns0:UnitofMeasureCode>
                      <xsl:text>PCS</xsl:text>
                    </ns0:UnitofMeasureCode>
                  </xsl:if>
                  <ns0:Quantity>
                    <xsl:value-of select="translate(normalize-space(lfimg), ',', '.')" />
                  </ns0:Quantity>
                  <ns0:OrderQuantity>
                    <xsl:value-of select="translate(normalize-space(lfimg), ',', '.')" />
                  </ns0:OrderQuantity>
                  <xsl:if test="brgew != '0.000'">
                    <ns0:GrossWeight>
                      <xsl:value-of select="brgew"/>
                    </ns0:GrossWeight>
                  </xsl:if>
                  <xsl:if test="ntgew != '0.000'">
                    <ns0:NetWeight>
                      <xsl:value-of select="ntgew"/>
                    </ns0:NetWeight>
                  </xsl:if>
                  <ns0:CommentText>
                    <!--PO Number-->
                    <xsl:value-of select="E2EDL41/bstnr"/>
                  </ns0:CommentText>
                  <xsl:if test="hievw = '1'">
                    <ns0:ItemCondition>FATHER</ns0:ItemCondition>
                  </xsl:if>
                  <xsl:if test="E2EDL41/bstdt != '00000000'">
                    <ns0:ActivityDate>
                      <xsl:value-of select="MyScript:ParseDate(E2EDL41/bstdt,'yyyyMMdd','yyyy-MM-dd')" />
                    </ns0:ActivityDate>
                  </xsl:if>
                  <ns0:Attribute01>
                    <xsl:value-of select="posnr"/>
                  </ns0:Attribute01>
                  <ns0:Attributes>
                    <ns0:Attribute>
                      <ns0:Code>ExtLineNo</ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="posnr"/>
                      </ns0:Value>
                    </ns0:Attribute>
                    <xsl:if test="hievw = '1'">
                      <xsl:value-of select="MyScript:SetMatnr(matnr)" />
                      <ns0:Attribute>
                        <ns0:Code>ARTREL</ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="hievw"/>
                        </ns0:Value>
                      </ns0:Attribute>
                    </xsl:if>
                    <xsl:if test="hievw = '2'">
                      <ns0:Attribute>
                        <ns0:Code>ARTREL</ns0:Code>
                        <ns0:Value>
                          <xsl:value-of select="MyScript:GetMatnr()" />
                        </ns0:Value>
                      </ns0:Attribute>
                    </xsl:if>
                  </ns0:Attributes>
                </ns0:DocumentLine>
              </xsl:for-each>
            </ns0:DocumentLines>
          </xsl:if>

        </ns0:Document>
      </ns0:Documents>
    </ns0:Message>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			

      public string MatNr = "";
      public void SetMatnr (string matin)
      {
          MatNr = matin;
      }
      
      public string GetMatnr ()
      {
          return MatNr;
      }
      
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
      
      public string AddDays(string inputDate, string formulaText, string formatIn, string formatOut)
      {
        DateTime Date = DateTime.ParseExact(inputDate, formatIn, null);
        Double formula = System.Convert.ToDouble(formulaText);
        DateTime OutputDate = Date.AddDays(formula);
        
        return OutputDate.ToString(formatOut);
      }

		]]>
  </msxsl:script>
</xsl:stylesheet>