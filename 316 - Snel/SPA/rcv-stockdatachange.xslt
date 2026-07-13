<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                exclude-result-prefixes="msxsl var MyScript s0" version="1.0"
                xmlns:s0="http://www.spadel.com/WATERFRONT/QAStatusChange"
                xmlns:ns0="www.boltrics.nl/stockdatachange:v1.00"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="s0:MT_QAStatusChange_WATERFRONT" />
  </xsl:template>
  
  <xsl:template match="s0:MT_QAStatusChange_WATERFRONT">
    <ns0:Message>
      <ns0:Header>
        <ns0:MessageID>
          <xsl:value-of select="MessageID" />
        </ns0:MessageID>
        <ns0:CreationDateTime>
          <xsl:value-of select="MyScript:GetCurrentDate('s')" />
        </ns0:CreationDateTime>
        <ns0:ProcesAction>
          <xsl:text>INSERT</xsl:text>
        </ns0:ProcesAction>
        <ns0:FromTradingPartner>
          <xsl:text>SPA</xsl:text>
        </ns0:FromTradingPartner>
        <ns0:ToTradingPartner>
          <xsl:text>Snel</xsl:text>
        </ns0:ToTradingPartner>
      </ns0:Header>
      <ns0:StockChanges>
        <ns0:StockChange>
          <ns0:CarrierNo>
            <xsl:value-of select="SSCC" />
          </ns0:CarrierNo>
          <ns0:EANCode>
            <xsl:value-of select="GTIN" />
          </ns0:EANCode>
          <ns0:ExpirationDate>
            <xsl:value-of select="MyScript:ParseDate(BestBeforeDate, 'yyyyMMdd', 'yyyy-MM-dd')" />
          </ns0:ExpirationDate>
          <ns0:BatchNo>
            <xsl:value-of select="Lot" />
          </ns0:BatchNo>
          <!--<ns0:ReasonCode>
               <xsl:value-of select="ReasonCode" />
               </ns0:ReasonCode>-->
          <ns0:NewCarrierStatus>
            <xsl:value-of select="Status" />
          </ns0:NewCarrierStatus>
        </ns0:StockChange>
      </ns0:StockChanges>      
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
