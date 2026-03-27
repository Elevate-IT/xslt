<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript" version="1.0"
                xmlns:ns0="www.boltrics.nl/receiveasn:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="VIO">
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
      <ns0:AdvancedNotices>
        <ns0:AdvancedNotice>
          <ns0:ExternalDocumentNo>
            <xsl:value-of select="MyScript:Split(StockData/OrderReferenceId, '|')" />
            <xsl:value-of select="StockData/OrderId" />
          </ns0:ExternalDocumentNo>
          <!--<ns0:ExternalNo>
            <xsl:value-of select="MyScript:GetFromSplitsArray(1)" />
          </ns0:ExternalNo>-->
          <ns0:GTIN>
            <xsl:value-of select="StockData/OrderId" />
          </ns0:GTIN>
          <ns0:NVESSCC18No>
            <xsl:value-of select="StockData/PalletSSCCcode" />
          </ns0:NVESSCC18No>
          <ns0:ProductionDate>
            <xsl:value-of select="MyScript:ParseDate(StockData/DateProduced, 'yyyyMMdd', 'yyyy-MM-dd')" />
          </ns0:ProductionDate>
          <ns0:OrderQuantity>
            <xsl:value-of select="StockData/QuantityPerPallet" />
          </ns0:OrderQuantity>
          <ns0:Attribute01>
            <xsl:value-of select="StockData/DestinationWarehouse" />
          </ns0:Attribute01>
          <ns0:Attribute02>
            <xsl:value-of select="StockData/PalletSeq" />
          </ns0:Attribute02>
          <ns0:Attribute03>
            <xsl:value-of select="StockData/StockOrder" />
          </ns0:Attribute03>
          <ns0:Attribute04>
            <xsl:value-of select="substring(MyScript:GetFromSplitsArray(2), 1, 30)" />
          </ns0:Attribute04>
        </ns0:AdvancedNotice>
      </ns0:AdvancedNotices>
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