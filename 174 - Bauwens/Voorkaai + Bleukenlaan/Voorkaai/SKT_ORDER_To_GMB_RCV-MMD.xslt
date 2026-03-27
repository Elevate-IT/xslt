<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/materialmasterdata:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="ORDER">
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

      <ns0:CustomerItems>
        <ns0:CustomerItem>
          <ns0:No>
            <xsl:value-of select="OrderData/OrderId" />
          </ns0:No>
          <ns0:Description>
            <xsl:value-of select="MyScript:Split(OrderData/OrderReferenceId, '|')" />
            <xsl:value-of select="substring(MyScript:GetFromSplitsArray(3), 1, 50)"/>
          </ns0:Description>
          <ns0:Description2>
            <xsl:value-of select="MyScript:GetFromSplitsArray(2)" />
          </ns0:Description2>
          <ns0:BaseUnitofMeasure>
            <xsl:value-of select="OrderData/StockType" />
          </ns0:BaseUnitofMeasure>
          <ns0:CarrierTypeCodeReceipt>
            <xsl:value-of select="OrderData/PalletsPerCombination[PalletType = 'G']/PalletDescription" />
          </ns0:CarrierTypeCodeReceipt>
          <ns0:CarrierTypeCodeShipment>
            <xsl:value-of select="OrderData/PalletsPerCombination[PalletType = 'G']/PalletDescription" />
          </ns0:CarrierTypeCodeShipment>
          <ns0:ExternalNo>
            <xsl:value-of select="MyScript:GetFromSplitsArray(1)"/>
          </ns0:ExternalNo>
          <ns0:UnitofMeasureatReceipt>
            <xsl:value-of select="OrderData/StockType" />
          </ns0:UnitofMeasureatReceipt>
          <ns0:UnitofMeasureatShipment>
            <xsl:value-of select="OrderData/StockType" />
          </ns0:UnitofMeasureatShipment>
          <ns0:UnitofMeasureatStorage>
            <xsl:value-of select="OrderData/StockType" />
          </ns0:UnitofMeasureatStorage>
          <ns0:Attribute02>
            <xsl:value-of select="OrderData/PalletsPerCombination[PalletType = 'T']/PalletDescription" />
          </ns0:Attribute02>
          <ns0:UnitOfMeasures>
            <ns0:UnitOfMeasure>
              <ns0:Code>
                <xsl:value-of select="OrderData/StockType" />
              </ns0:Code>
              <ns0:GrossWeight>
                <xsl:value-of select="format-number(translate(OrderData/WeightPer1000Pieces, ',', '.') div 1000, '#.#####')" />
              </ns0:GrossWeight>
              <ns0:NetWeight>
                <xsl:value-of select="format-number(translate(OrderData/WeightPer1000Pieces, ',', '.') div 1000, '#.#####')" />
              </ns0:NetWeight>
              <ns0:EANCode>
                <xsl:value-of select="OrderData/OrderEanId" />
              </ns0:EANCode>
              <ns0:UnitOfMeasureCarriers>
                <ns0:UnitOfMeasureCarrier>
                  <ns0:CarrierTypeCode>
                    <xsl:value-of select="OrderData/PalletsPerCombination[PalletType = 'G']/PalletDescription" />
                  </ns0:CarrierTypeCode>
                  <xsl:if test="OrderData/QuantityPerPallet != ''">
                    <ns0:QtyperUOMCode>
                      <xsl:value-of select="OrderData/QuantityPerPallet" />
                    </ns0:QtyperUOMCode>
                  </xsl:if>
                  <xsl:value-of select="MyScript:Split(OrderData/PalletDimensions, '*')" />
                  <xsl:if test="MyScript:GetFromSplitsArray(0) != ''">
                    <ns0:Length>
                      <xsl:value-of select="MyScript:GetFromSplitsArray(0)" />
                    </ns0:Length>
                  </xsl:if>
                  <xsl:if test="MyScript:GetFromSplitsArray(1) != ''">
                    <ns0:Width>
                      <xsl:value-of select="MyScript:GetFromSplitsArray(1)" />
                    </ns0:Width>
                  </xsl:if>
                  <xsl:if test="OrderData/PalletHeight != ''">
                    <ns0:Height>
                      <xsl:value-of select="OrderData/PalletHeight" />
                    </ns0:Height>
                  </xsl:if>
                </ns0:UnitOfMeasureCarrier>
              </ns0:UnitOfMeasureCarriers>
            </ns0:UnitOfMeasure>
          </ns0:UnitOfMeasures>
          <ns0:Conditions>
            <ns0:Condition>
              <ns0:ConditionCode>
                <xsl:text>PILE PAL</xsl:text>
              </ns0:ConditionCode>
              <ns0:ConditionValue>
                <xsl:value-of select="OrderData/PilePallets" />
              </ns0:ConditionValue>
            </ns0:Condition>
            <ns0:Condition>
              <ns0:ConditionCode>
                <xsl:text>FOIL WRAP</xsl:text>
              </ns0:ConditionCode>
              <ns0:ConditionValue>
                <xsl:value-of select="OrderData/FoilWrappedPallets" />
              </ns0:ConditionValue>
            </ns0:Condition>
          </ns0:Conditions>
        </ns0:CustomerItem>
      </ns0:CustomerItems>

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