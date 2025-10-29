<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/sendreceipt:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:Message/s0:Documents/s0:Document" />
  </xsl:template>
  <xsl:template match="//s0:Message/s0:Documents/s0:Document">
    <ns0:EFACT_D96A_RECADV>
      <UNH>
        <UNH1>
          <xsl:value-of select="//s0:Header/s0:MessageID" />
        </UNH1>
        <UNH2>
          <UNH2.1>RECADV</UNH2.1>
          <UNH2.2>D</UNH2.2>
          <UNH2.3>96A</UNH2.3>
          <UNH2.4>UN</UNH2.4>
        </UNH2>
      </UNH>
      <ns0:BGM>
        <ns0:C002>
          <C00201>352</C00201>
        </ns0:C002>
        <BGM02>
          <xsl:value-of select="translate(s0:ExternalDocumentNo,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
        </BGM02>
        <BGM03>9</BGM03>
      </ns0:BGM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>137</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(//s0:CreationDateTime, 's', 'yyyyMMdd')" />
          </C50702>
          <C50703>102</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:DTM>
        <ns0:C507>
          <C50701>50</C50701>
          <C50702>
            <xsl:value-of select="MyScript:ParseDate(//s0:PostingDate, 'yyyy-MM-dd', 'yyyyMMdd')" />
          </C50702>
          <C50703>102</C50703>
        </ns0:C507>
      </ns0:DTM>
      <ns0:RFFLoop1>
        <ns0:RFF>
          <ns0:C506>
            <C50601>ON</C50601>
            <C50602>
              <xsl:value-of select="translate(s0:ExternalDocumentNo,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
            </C50602>
          </ns0:C506>
        </ns0:RFF>
      </ns0:RFFLoop1>
      <ns0:CPSLoop1>
        <ns0:CPS>
          <CPS01>1</CPS01>
        </ns0:CPS>

        <xsl:for-each select="s0:DocumentLines/s0:DocumentLine[s0:Type='1']">
          <ns0:LINLoop1>
            <ns0:LIN>
              <LIN01>
                <xsl:value-of select="MyScript:GetLinCounter()" />
              </LIN01>
            </ns0:LIN>
            <ns0:PIA>
              <PIA01>5</PIA01>
              <ns0:C212_2>
                <C21201>
                  <xsl:value-of select="s0:ExternalNo" />
                </C21201>
                <C21202>SA</C21202>
              </ns0:C212_2>
            </ns0:PIA>
            <ns0:QTY>
              <ns0:C186>
                <C18601>21</C18601>
                <C18602>
                  <xsl:value-of select="s0:QtyPosted" />
                </C18602>
                <C18603>SU</C18603>
              </ns0:C186>
            </ns0:QTY>
            <ns0:QTY>
              <ns0:C186>
                <C18601>22</C18601>
                <C18602>
                  <xsl:value-of select="format-number(s0:QtyBasePosted, '#.000')" />
                </C18602>
                <C18603>
                  <xsl:choose>
                    <xsl:when test="s0:BaseUnitofMeasureCode = 'LITER'">LTR</xsl:when>
                    <xsl:when test="s0:BaseUnitofMeasureCode = 'KILO'">KGM</xsl:when>
                    <xsl:when test="s0:BaseUnitofMeasureCode = 'KG'">KGM</xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="substring(s0:BaseUnitofMeasureCode, 1, 3)" />
                    </xsl:otherwise>
                  </xsl:choose>
                </C18603>
              </ns0:C186>
            </ns0:QTY>
          </ns0:LINLoop1>

          <!--<xsl:if test="count(s0:DocumentDetailLines/s0:DocumentDetailLine) = 0">
            <ns0:LINLoop1>
            <ns0:LIN>
              <LIN01>
                <xsl:value-of select="MyScript:GetLinCounter()" />
              </LIN01>
            </ns0:LIN>
            <ns0:PIA>
              <PIA01>5</PIA01>
              <ns0:C212_2>
                <C21201>
                  <xsl:value-of select="s0:ExternalNo" />
                </C21201>
                <C21202>SA</C21202>
              </ns0:C212_2>
            </ns0:PIA>
            <ns0:QTY>
              <ns0:C186>
                <C18601>21</C18601>
                <C18602>0</C18602>
                <C18603>SU</C18603>
              </ns0:C186>
            </ns0:QTY>
            <ns0:QTY>
              <ns0:C186>
                <C18601>22</C18601>
                <C18602>0</C18602>
                <C18603>
                  <xsl:choose>
                    <xsl:when test="s0:OrderUnitofMeasureCode = 'LITER'">`LTR</xsl:when>
                    <xsl:when test="s0:OrderUnitofMeasureCode = 'KILO'">`KGM</xsl:when>
                    <xsl:when test="s0:OrderUnitofMeasureCode = 'KG'">`KGM</xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="substring(s0:OrderUnitofMeasureCode, 1, 3)" /></xsl:otherwise>
                  </xsl:choose>
                </C18603>
              </ns0:C186>
            </ns0:QTY>
          </ns0:LINLoop1>
          </xsl:if>-->
        </xsl:for-each>
      </ns0:CPSLoop1>
    </ns0:EFACT_D96A_RECADV>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			
      int CPSCounter = 0;
      public string GetCPSCounter()
      {
        return (++CPSCounter).ToString();
      }
      
      public int NRCounter2 = 1;
      public string GetNRCounter2(bool increment)
      {
        if (increment)
          NRCounter2 += 1;
        return (NRCounter2).ToString();
      }
      
      public string GetNRCounter3()
      {
        return (NRCounter2 - 1).ToString();
      }
            
      public int NRCounter = 0;
      public string GetNRCounter(bool increment)
      {
        if (increment){
          NRCounter2 = 1;
          NRCounter += 1;
        }        
        return (NRCounter).ToString();
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
      
      public string ParseDate(string input, string formatIn, string formatOut)

      {
        DateTime dateT = DateTime.ParseExact(input, formatIn, null);
        return dateT.ToString(formatOut);
      }
      
      public string GetGUID()
      {
        return "{"+Guid.NewGuid().ToString()+"}";
      }
      
    public int QtyOnCarrier {get;set;}
    public void AddToQtyOnCarrier(int qtyOnCarrier)
	  {       
       QtyOnCarrier = QtyOnCarrier + qtyOnCarrier;             
    }
    
    public void SetQtyOnCarrier(int qtyOnCarrier)
	  {       
       QtyOnCarrier = qtyOnCarrier;             
    }
    
    public int GetQtyOnCarrier()
	  {       
       return QtyOnCarrier;             
    }
             
    public int QtyOnCarrierRetour {get;set;}
    public void AddToQtyOnCarrierRetour(int qtyOnCarrierRetour)
	  {       
       QtyOnCarrierRetour = QtyOnCarrierRetour + qtyOnCarrierRetour;             
    }
    
    public void SetQtyOnCarrierRetour(int qtyOnCarrierRetour)
	  {       
       QtyOnCarrierRetour = qtyOnCarrierRetour;             
    }
    
    public int GetQtyOnCarrierRetour()
	  {       
       return QtyOnCarrierRetour;             
    }
      
		]]>
  </msxsl:script>
</xsl:stylesheet>