<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receiveshipment:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="DESPATCH" />
  </xsl:template>
  <xsl:template match="DESPATCH">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="UNH/MessageId" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="MyScript:GetCurrentDate('s')" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:text>1993</xsl:text>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:value-of select="UNH/Receiver" />
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:Documents>
        <xsl:for-each select="DELIVERY">
          <ns0:Document>
            <ns0:BuildingCode>
              <xsl:choose>
                <xsl:when test="MyScript:ToUpper(DespatchData/PickingInstructions) = '1993'">
                  <xsl:text>VOORKAAI</xsl:text>
                </xsl:when>
                <xsl:when test="MyScript:ToUpper(DespatchData/PickingInstructions) = '900'">
                  <xsl:text>BL</xsl:text>
                </xsl:when>
                <xsl:when test="MyScript:ToUpper(DespatchData/PickingInstructions) = '100'">
                  <xsl:text>TURNHOUT 1</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>BL</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </ns0:BuildingCode>
            <ns0:DocumentDate>
              <xsl:value-of select="MyScript:GetCurrentDate('yyyy-MM-dd')" />
            </ns0:DocumentDate>
            <ns0:PostingDate>
              <xsl:value-of select="MyScript:ParseDate(DespatchData/CarrierRunDate, 'yyyyMMdd', 'yyyy-MM-dd')" />
            </ns0:PostingDate>
            <ns0:ExternalDocumentNo>
              <xsl:value-of select="concat(DespatchData/CarrierRunId, '-', CallOffData/DeliveryAddressId, '-', DespatchData/LoadSeq)" />
            </ns0:ExternalDocumentNo>

            <ns0:ShippingAgent>
              <ns0:ExternalNo>
                <xsl:value-of select="DespatchData/CarrierAddressId" />
              </ns0:ExternalNo>
              <ns0:Name>
                <xsl:value-of select="DespatchData/CarrierName" />
              </ns0:Name>
              <ns0:Address>
                <xsl:value-of select="DespatchData/CarrierName2" />
              </ns0:Address>
              <ns0:Address2>
                <xsl:value-of select="DespatchData/CarrierAddress" />
              </ns0:Address2>
              <ns0:City>
                <xsl:value-of select="DespatchData/CarrierCity" />
              </ns0:City>
              <ns0:PostCode>
                <xsl:value-of select="DespatchData/CarrierZip" />
              </ns0:PostCode>
              <ns0:CountryCode>
                <xsl:value-of select="DespatchData/CarrierCountryId" />
              </ns0:CountryCode>
            </ns0:ShippingAgent>

            <ns0:OrderTypeCode>
              <xsl:text>SMURFITKAPPA</xsl:text>
            </ns0:OrderTypeCode>

            <ns0:ShipToAddress>
              <ns0:ExternalNo>
                <xsl:value-of select="CallOffData/DeliveryAddressId" />
              </ns0:ExternalNo>
              <ns0:Name>
                <xsl:value-of select="CallOffData/DeliveryName" />
              </ns0:Name>
              <ns0:Address>
                <xsl:value-of select="CallOffData/DeliveryName2" />
              </ns0:Address>
              <ns0:Address2>
                <xsl:value-of select="CallOffData/DeliveryAddress" />
              </ns0:Address2>
              <ns0:City>
                <xsl:value-of select="CallOffData/DeliveryCity" />
              </ns0:City>
              <ns0:PostCode>
                <xsl:value-of select="CallOffData/DeliveryZip" />
              </ns0:PostCode>
              <ns0:CountryCode>
                <xsl:value-of select="CallOffData/DeliveryCountryId" />
              </ns0:CountryCode>
            </ns0:ShipToAddress>

            <ns0:TripNo>
              <xsl:value-of select="DespatchData/CarrierRunId" />
            </ns0:TripNo>
            <ns0:SequenceNo>
              <xsl:value-of select="DespatchData/LoadSeq" />
            </ns0:SequenceNo>

            <!--<ns0:CarrierAddress>
              <ns0:ExternalNo>
                <xsl:value-of select="DespatchData/CarrierAddressId" />
              </ns0:ExternalNo>
              <ns0:Name>
                <xsl:value-of select="DespatchData/CarrierName" />
              </ns0:Name>
              <ns0:Address>
                <xsl:value-of select="DespatchData/CarrierName2" />
              </ns0:Address>
              <ns0:Address2>
                <xsl:value-of select="DespatchData/CarrierAddress" />
              </ns0:Address2>
              <ns0:City>
                <xsl:value-of select="DespatchData/CarrierCity" />
              </ns0:City>
              <ns0:PostCode>
                <xsl:value-of select="DespatchData/CarrierZip" />
              </ns0:PostCode>
              <ns0:CountryCode>
                <xsl:value-of select="DespatchData/CarrierCountryId" />
              </ns0:CountryCode>
            </ns0:CarrierAddress>-->

            <ns0:Attributes>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_CUSTID</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="//CustomerId"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_NAME</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="//CustomerName"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_NAM2</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="//CustomerName2"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_ADDR</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="//CustomerAddress"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_ZIP</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="//CustomerZip"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_CITY</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="//CustomerCity"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_CID</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="//CustomerCountryId"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_VAT</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="//CustomerVATNr"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_PHONE</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="//CustomerPhone"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_C_FAX</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="//CustomerFax"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_CRRUNDT</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="//CarrierRunDate"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_INCTERM</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="//IncoTerms"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_PLR1</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="//PackingListRemark1"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_PLR2</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="//PackingListRemark2"/>
                </ns0:Value>
              </ns0:Attribute>
              <ns0:Attribute>
                <ns0:Code>
                  <xsl:text>SK_CARRID</xsl:text>
                </ns0:Code>
                <ns0:Value>
                  <xsl:value-of select="DespatchData/CarrierRunId"/>
                </ns0:Value>
              </ns0:Attribute>
            </ns0:Attributes>

            <ns0:DocumentLines>
              <xsl:for-each select="CallOffData">
                <xsl:variable name="DeliveryLineID" select="DeliveryLineId" />
                <ns0:DocumentLine>
                  <ns0:No>
                    <xsl:value-of select="OrderId" />
                  </ns0:No>
                  <ns0:OrderUnitofMeasureCode>
                    <xsl:value-of select="StockType" />
                  </ns0:OrderUnitofMeasureCode>
                  <ns0:OrderQuantity>
                    <xsl:value-of select="CallOffQuantity" />
                  </ns0:OrderQuantity>
                  <ns0:QtyPerCarrier>
                    <xsl:value-of select="../DespatchData[DeliveryLineId = $DeliveryLineID]/PalletsDespatch/NumberOfPiecesPerPallet" />
                  </ns0:QtyPerCarrier>
                  <ns0:Attributes>
                    <ns0:Attribute>
                      <ns0:Code>
                        <xsl:text>SK_CALLOFF</xsl:text>
                      </ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="CallOffId" />
                      </ns0:Value>
                    </ns0:Attribute>
                    <ns0:Attribute>
                      <ns0:Code>
                        <xsl:text>SK_CUSTAID</xsl:text>
                      </ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="CustomerItemCode"/>
                      </ns0:Value>
                    </ns0:Attribute>
                    <ns0:Attribute>
                      <ns0:Code>
                        <xsl:text>SK_C_ORDRE</xsl:text>
                      </ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="CustomerOrderReference"/>
                      </ns0:Value>
                    </ns0:Attribute>
                    <ns0:Attribute>
                      <ns0:Code>
                        <xsl:text>SK_CODESCR</xsl:text>
                      </ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="CustomerCallOffDescription"/>
                      </ns0:Value>
                    </ns0:Attribute>
                    <ns0:Attribute>
                      <ns0:Code>
                        <xsl:text>SK_FSC_YN</xsl:text>
                      </ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="CustomerItemFSCYesNo"/>
                      </ns0:Value>
                    </ns0:Attribute>
                    <ns0:Attribute>
                      <ns0:Code>
                        <xsl:text>SK_FSC_T</xsl:text>
                      </ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="CustomerItemFSCText"/>
                      </ns0:Value>
                    </ns0:Attribute>
                    <ns0:Attribute>
                      <ns0:Code>
                        <xsl:text>SK_CR_SEQ</xsl:text>
                      </ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="../DespatchData[DeliveryLineId = $DeliveryLineID]/CarrierRunSeqId"/>
                      </ns0:Value>
                    </ns0:Attribute>
                    <ns0:Attribute>
                      <ns0:Code>
                        <xsl:text>SK_LR1</xsl:text>
                      </ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="../DespatchData[DeliveryLineId = $DeliveryLineID]/LineRemark1"/>
                      </ns0:Value>
                    </ns0:Attribute>
                    <ns0:Attribute>
                      <ns0:Code>
                        <xsl:text>SK_LR2</xsl:text>
                      </ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="../DespatchData[DeliveryLineId = $DeliveryLineID]/LineRemark2"/>
                      </ns0:Value>
                    </ns0:Attribute>
                    <ns0:Attribute>
                      <ns0:Code>
                        <xsl:text>SK_PA_GRND</xsl:text>
                      </ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="../DespatchData[DeliveryLineId = $DeliveryLineID]/PalletsPerCombination[PalletType = 'G']/PalletAgreement"/>
                      </ns0:Value>
                    </ns0:Attribute>
                    <ns0:Attribute>
                      <ns0:Code>
                        <xsl:text>SK_PA_TOP</xsl:text>
                      </ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="../DespatchData[DeliveryLineId = $DeliveryLineID]/PalletsPerCombination[PalletType = 'T']/PalletAgreement"/>
                      </ns0:Value>
                    </ns0:Attribute>
                    <ns0:Attribute>
                      <ns0:Code>
                        <xsl:text>SK_THEORST</xsl:text>
                      </ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="TheoreticalStock"/>
                      </ns0:Value>
                    </ns0:Attribute>
                    <ns0:Attribute>
                      <ns0:Code>
                        <xsl:text>SK_PCSPPAL</xsl:text>
                      </ns0:Code>
                      <ns0:Value>
                        <xsl:value-of select="../DespatchData[DeliveryLineId = $DeliveryLineID]/PalletsDespatch/NumberOfPiecesPerPallet" />
                      </ns0:Value>
                    </ns0:Attribute>
                  </ns0:Attributes>
                </ns0:DocumentLine>
              </xsl:for-each>
            </ns0:DocumentLines>

          </ns0:Document>
        </xsl:for-each>
      </ns0:Documents>
    </ns0:Message>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			

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
      
      public string ToUpper(string input)
			{
				return input.ToUpper();
			}
      
      public string[] splits;
      
      public void Split(string input, string seperator)
      {
        char seperatorChar = Convert.ToChar(seperator);
        splits = input.Split(seperatorChar);
      }
      
      public string GetFromSplitsArray(int i)
      {
        return splits[i];
      }

		]]>
  </msxsl:script>
</xsl:stylesheet>