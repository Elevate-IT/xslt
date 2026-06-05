<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/sendreceipt:v1.00"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:key name="UniqueSourceCarrierBySSCC" match="//s0:Carrier" use="s0:SSCCNo" />
  <xsl:template match="/">
    <xsl:apply-templates select="/s0:Message/s0:Documents/s0:Document" />
  </xsl:template>
  <xsl:template match="/s0:Message/s0:Documents/s0:Document">
    <xsl:if test="s0:StatusCode!='01-GEANNULEERD'">
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
          <UNH4>
            <UNH4.1>0</UNH4.1>
          </UNH4>
        </UNH>
        <ns0:BGM>
          <ns0:C002>
            <C00201>352</C00201>
          </ns0:C002>
          <BGM02>
             <xsl:value-of select="s0:ExternalDocumentNo" />
          </BGM02>
          <BGM03>9</BGM03>
        </ns0:BGM>
        <ns0:DTM>
          <ns0:C507>
            <C50701>137</C50701>
            <C50702>
              <xsl:value-of select="MyScript:ParseDate(//s0:CreationDateTime, 's', 'yyyyMMddHHmm')" />
            </C50702>
            <C50703>203</C50703>
          </ns0:C507>
        </ns0:DTM>
        <ns0:RFFLoop1>
          <ns0:RFF>
            <ns0:C506>
              <C50601>VN</C50601>
              <C50602>
                <xsl:value-of select="normalize-space(substring(translate(s0:ExternalDocumentNo,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),1,35))" />
              </C50602>
            </ns0:C506>
          </ns0:RFF>
        </ns0:RFFLoop1>
        <xsl:if test="string-length(s0:ExternalReference)&gt;0">
          <ns0:RFFLoop1>
            <ns0:RFF>
              <ns0:C506>
                <C50601>ON</C50601>
                <C50602>
                  <xsl:value-of select="normalize-space(substring(translate(s0:ExternalReference,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),1,35))" />
                </C50602>
              </ns0:C506>
            </ns0:RFF>
          </ns0:RFFLoop1>
        </xsl:if>
        <ns0:RFFLoop1>
          <ns0:RFF>
            <ns0:C506>
              <C50601>AAJ</C50601>
              <C50602>
                <xsl:value-of select="translate(s0:No,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
              </C50602>
            </ns0:C506>
          </ns0:RFF>
        </ns0:RFFLoop1>
        <ns0:NADLoop1>
          <ns0:NAD>
            <NAD01>SH</NAD01>
            <ns0:C082>
              <C08201>
                <xsl:value-of select="//s0:FromTradingPartner" />
              </C08201>
              <C08203>9</C08203>
            </ns0:C082>
          </ns0:NAD>
        </ns0:NADLoop1>
        <ns0:NADLoop1>
          <ns0:NAD>
            <NAD01>SU</NAD01>
            <ns0:C082>
              <C08201>
                <xsl:value-of select="//s0:ToTradingPartner" />
              </C08201>
              <C08203>9</C08203>
            </ns0:C082>
          </ns0:NAD>
        </ns0:NADLoop1>
        <ns0:NADLoop1>
          <ns0:NAD>
            <NAD01>DP</NAD01>
            <xsl:choose>
              <xsl:when test="string-length(s0:ShipToAddress/s0:EANCode)&gt;0" >
                <ns0:C082>
                  <C08201>
                    <xsl:value-of select="s0:ShipToAddress/s0:EANCode" />
                  </C08201>
                  <C08203>9</C08203>
                </ns0:C082>
              </xsl:when>
              <xsl:otherwise>
                <ns0:C082>
                  <C08201>
                    <xsl:value-of select="normalize-space(s0:ShipToAddress/s0:Attribute10)" />
                  </C08201>
                  <C08203>91</C08203>
                </ns0:C082>
                <ns0:C080>
                  <C08001>
                    <xsl:value-of select="substring(normalize-space(s0:ShipToAddress/s0:Name),1,35)"/>
                  </C08001>
                </ns0:C080>
                <ns0:C059>
                  <C05901>
                    <xsl:choose>
                      <xsl:when test="contains(normalize-space(s0:ShipToAddress/s0:Address),normalize-space(s0:ShipToAddress/s0:AddressNo))">
                        <xsl:value-of select="substring(normalize-space(s0:ShipToAddress/s0:Address),1,35)"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="substring(normalize-space(concat(s0:ShipToAddress/s0:Address , ' ' , s0:ShipToAddress/s0:AddressNo)),1,35)"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </C05901>
                   <xsl:choose>
                      <xsl:when test="contains(normalize-space(s0:ShipToAddress/s0:Address),normalize-space(s0:ShipToAddress/s0:AddressNo))">
                         <xsl:if test="string-length(normalize-space(s0:ShipToAddress/s0:Address)) > 35">
                            <C05902>                 
                            <xsl:value-of select="normalize-space(substring(s0:ShipToAddress/s0:Address,36,35))"/>
                            </C05902>
                         </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                         <xsl:if test="string-length(normalize-space(concat(s0:ShipToAddress/s0:Address , ' ' , s0:ShipToAddress/s0:AddressNo))) > 35">
                            <C05902>
                               <xsl:value-of select="normalize-space(substring(concat(s0:ShipToAddress/s0:Address , ' ' , s0:ShipToAddress/s0:AddressNo),36,35))"/>
                            </C05902>
                         </xsl:if>
                      </xsl:otherwise>
                   </xsl:choose>                  
                </ns0:C059>
                <NAD06>
                  <xsl:value-of select="normalize-space(s0:ShipToAddress/s0:City)"/>
                </NAD06>
                <NAD08>
                  <xsl:value-of select="normalize-space(s0:ShipToAddress/s0:PostCode)"/>
                </NAD08>
                <NAD09>
                  <xsl:value-of select="s0:ShipToAddress/s0:CountryRegionCode"/>
                </NAD09>
              </xsl:otherwise>
            </xsl:choose>
          </ns0:NAD>
        </ns0:NADLoop1>
        <xsl:if test="string-length(s0:ContainerNo)&gt;0">
          <ns0:EQDLoop1>
            <ns0:EQD>
              <EQD01>CN</EQD01>
              <ns0:C237>
                <C23701>
                  <xsl:value-of select="s0:ContainerNo"/>
                </C23701>
              </ns0:C237>
            </ns0:EQD>
            <xsl:if test="string-length(s0:SealNo)&gt;0">
              <ns0:SELLoop1>
                <ns0:SEL>
                  <SEL01>
                    <xsl:value-of select="substring(s0:SealNo,1,10)"/>  
                  </SEL01>
                </ns0:SEL>
              </ns0:SELLoop1>
              <xsl:if test="string-length(s0:SealNo)&gt;10">
                <ns0:SELLoop1>
                  <ns0:SEL>
                    <SEL01>
                      <xsl:value-of select="substring(s0:SealNo,11,10)"/>
                    </SEL01>
                  </ns0:SEL>
                </ns0:SELLoop1>                  
              </xsl:if>
              <xsl:if test="string-length(s0:SealNo)&gt;20">
                <ns0:SELLoop1>
                  <ns0:SEL>
                    <SEL01>
                      <xsl:value-of select="substring(translate(s0:SealNo,' ',''),21,10)"/>
                    </SEL01>
                  </ns0:SEL>
                </ns0:SELLoop1>
              </xsl:if>
            </xsl:if>
          </ns0:EQDLoop1>
        </xsl:if>
        <xsl:if test="(s0:Carriers/s0:Carrier[s0:CarrierTypeCode='T']) or (s0:DocumentLines/s0:DocumentLine[s0:Type='1']/s0:Attribute03!=0) or (s0:DocumentLines/s0:DocumentLine[s0:Type='3' and s0:Quantity&gt;0]/s0:PackageRefund='1')">
          <ns0:CPSLoop1>
            <ns0:CPS>
              <CPS01>1</CPS01>
            </ns0:CPS>
            <!--          </xsl:if>  -->
            <xsl:for-each select="s0:Carriers/s0:Carrier">
              <xsl:if test="s0:CarrierTypeCode='T'">
                <xsl:if test="s0:PackageRefund='1'">
                  <ns0:PACLoop1>
                    <ns0:PAC>
                      <PAC01>1</PAC01>
                      <xsl:value-of select="MyScript:AddToQtyOnCarrier(1)"/>
                      <ns0:C531>
                        <C53103>2</C53103>
                      </ns0:C531>
                      <ns0:C202>
                        <C20201>
                          <xsl:value-of select="s0:PackageISOCode"/>
                        </C20201>
                      </ns0:C202>
                    </ns0:PAC>
                    <ns0:PCILoop1>
                      <ns0:PCI>
                        <PCI01>17</PCI01>
                        <ns0:C210>
                          <C21001>
                            <xsl:value-of select="format-number(s0:ExternalCarrierNo,'000000')"/>
                          </C21001>
                        </ns0:C210>
                      </ns0:PCI>
                    </ns0:PCILoop1>
                  </ns0:PACLoop1>
                </xsl:if>
              </xsl:if>
            </xsl:for-each>

            <xsl:for-each select="(s0:DocumentLines/s0:DocumentLine[s0:Type='3'])">
              <xsl:if test="(s0:PackageRefund='1') and (s0:No!='T')">
                <xsl:choose>
                  <xsl:when test="s0:Quantity&gt;0">
                    <xsl:value-of select="MyScript:AddToQtyOnCarrier(s0:Quantity)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="MyScript:AddToQtyOnCarrierRetour(-1*s0:Quantity)"/>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="string-length(s0:PackageISOCode)&gt;0">
                  <ns0:PACLoop1>
                    <ns0:PAC>
                      <PAC01>
                        <xsl:choose>
                          <xsl:when test="s0:Quantity&gt;0">
                            <xsl:value-of select="s0:Quantity"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="-1*s0:Quantity"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </PAC01>
                      <ns0:C531>
                        <C53103>2</C53103>
                      </ns0:C531>
                      <ns0:C202>
                        <C20201>
                          <xsl:value-of select="s0:PackageISOCode"/>
                        </C20201>
                      </ns0:C202>
                    </ns0:PAC>
                  </ns0:PACLoop1>
                </xsl:if>
              </xsl:if>
            </xsl:for-each>

            <xsl:if test="(MyScript:GetQtyOnCarrier())&gt;0">
              <ns0:PACLoop1>
                <ns0:PAC>
                  <PAC01>
                    <xsl:value-of select="MyScript:GetQtyOnCarrier()"/>
                  </PAC01>
                  <ns0:C531>
                    <C53103>2</C53103>
                  </ns0:C531>
                  <ns0:C202>
                    <C20201>09</C20201>
                  </ns0:C202>
                </ns0:PAC>
              </ns0:PACLoop1>
            </xsl:if>
            <xsl:if test="(MyScript:GetQtyOnCarrierRetour())&gt;0">
              <ns0:PACLoop1>
                <ns0:PAC>
                  <PAC01>
                    <xsl:value-of select="MyScript:GetQtyOnCarrierRetour()"/>
                  </PAC01>
                  <ns0:C531>
                    <C53103>1</C53103>
                  </ns0:C531>
                  <ns0:C202>
                    <C20201>09</C20201>
                  </ns0:C202>
                </ns0:PAC>
              </ns0:PACLoop1>
            </xsl:if>


        </ns0:CPSLoop1>
        </xsl:if>
        <xsl:if test="(sum(s0:DocumentLines/s0:DocumentLine[s0:Type='1']/s0:Attribute03))!=0">
          <xsl:for-each select="s0:DocumentLines/s0:DocumentLine[s0:Type='1']">
            <xsl:if test="s0:Attribute03!=0">
              <xsl:variable name="orderLineNumber" select="s0:Attributes/s0:Attribute[s0:Code='ORDERLINE']/s0:Value" />
              <xsl:variable name="LineNo" select="s0:LineNo"/>
              <ns0:CPSLoop1>
                <ns0:LINLoop1>
                  <ns0:LIN>
                    <LIN01>
                      <xsl:choose>
                        <xsl:when test="string-length($orderLineNumber)&gt;0">
                          <xsl:value-of select="$orderLineNumber"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="MyScript:GetLinCounter()"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </LIN01>
                    <ns0:C212>
                      <C21201>
                        <xsl:value-of select="s0:EANCode" />
                      </C21201>
                      <C21202>EN</C21202>
                    </ns0:C212>
                  </ns0:LIN>
                  <xsl:if test="string-length(s0:ExternalNo)&gt;0">
                    <ns0:PIA>
                      <PIA01>5</PIA01>
                      <ns0:C212_2>
                        <C21201>
                          <xsl:value-of select="s0:ExternalNo" />
                        </C21201>
                        <C21202>SA</C21202>
                      </ns0:C212_2>
                    </ns0:PIA>
                  </xsl:if>
                  <xsl:if test="string-length(s0:ProductVariant)&gt;0">
                    <ns0:PIA>
                      <PIA01>1</PIA01>
                      <ns0:C212_2>
                        <C21201>
                          <xsl:value-of select="s0:ProductVariant" />
                        </C21201>
                        <C21202>PV</C21202>
                      </ns0:C212_2>
                    </ns0:PIA>
                  </xsl:if>
              
                  <ns0:QTY>
                    <ns0:C186>
                      <C18601>21</C18601>
                      <C18602>
                        <xsl:value-of select="s0:OrderQuantity"/>
                      </C18602>
                    </ns0:C186>
                  </ns0:QTY>
                  <ns0:QTY>
                    <ns0:C186>
                      <C18601>12</C18601>
                      <C18602>
                        <xsl:choose>
                        <xsl:when test="s0:QtyPosted">
                        <xsl:value-of select="s0:QtyPosted"/>
                        </xsl:when>
                          <xsl:otherwise>0</xsl:otherwise>
                        </xsl:choose>
                      </C18602>
                    </ns0:C186>
                  </ns0:QTY>
                  <ns0:QTY>
                    <ns0:C186>
                      <C18601>194</C18601>
                      <C18602>
                        <xsl:value-of select="(s0:QtyPosted + s0:Attribute03)"/>
                      </C18602>
                    </ns0:C186>
                  </ns0:QTY>
                  <ns0:QVR_2>
                    <ns0:C279_2>
                      <C27901>
                        <xsl:value-of select="translate(s0:Attribute03,'-','')"/>
                      </C27901>
                      <C27902>
                        <xsl:choose>
                          <xsl:when test="MyScript:ConvertReasonCode(s0:Attribute04)='194/195'">
                            <xsl:choose>
                              <xsl:when test="s0:Attribute03&lt;0">
                                <xsl:text>195</xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:text>194</xsl:text>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="MyScript:ConvertReasonCode(s0:Attribute04)"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </C27902>
                    </ns0:C279_2>
                    <QVR02>
                      <xsl:value-of select="s0:Attribute04"/>
                    </QVR02>
                  </ns0:QVR_2>
                </ns0:LINLoop1>
              </ns0:CPSLoop1>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="(sum(s0:DocumentLines/s0:DocumentLine[s0:Type='1']/s0:Attribute03))=0">
          <ns0:CNT>
            <ns0:C270>
              <C27001>1</C27001>
              <C27002>
                <xsl:value-of select="sum(s0:DocumentLines/s0:DocumentLine/s0:QtyPosted)" />
              </C27002>
            </ns0:C270>
          </ns0:CNT>
        </xsl:if>
      </ns0:EFACT_D96A_RECADV>
    </xsl:if>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			
      int CPSCounter = 0;
      public string GetCPSCounter()
      {
        return (++CPSCounter).ToString();
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
      
      public string ConvertReasonCode(string Reason)
	    {  
		    switch (Reason)
		    {
			    case "180":
				    return "73";
				    break;

			    case "201":
				    return "73";
				    break;

			    case "206":
				    return "73";
				    break;

			    case "207":
				    return "73";
				    break;

			    case "210":
				    return "73";
				    break;

			    case "212":
				    return "73";
				    break;

			    case "215":
				    return "73";
				    break;

			    case "220":
				    return "73";
				    break;

			    case "221":
				    return "194/195";
				    break;

			    case "222":
				    return "194/195";
				    break;

			    case "223":
				    return "194/195";
				    break;

			    case "224":
				    return "194/195";
				    break;

			    case "225":
				    return "73";
				    break;

			    case "227":
				    return "195";
				    break;

			    case "229":
				    return "";
				    break;

			    case "233":
				    return "195";
				    break;

			    case "234":
				    return "";
				    break;

			    case "241":
				    return "194";
				    break;

			    case "247":
				    return "194";
				    break;

			    case "248":
				    return "194";
				    break;

			    case "261":
				    return "195";
				    break;

			    case "262":
				    return "195";
				    break;

			    case "265":
				    return "73";
				    break;

			    case "266":
				    return "73";
				    break;

			    case "267":
				    return "73";
				    break;

			    case "268":
				    return "73";
				    break;

			    case "269":
				    return "73";
				    break;

			    case "271":
				    return "73";
				    break;

			    case "272":
				    return "73";
				    break;

			    case "275":
				    return "73";
				    break;

			    case "300":
				    return "195";
				    break;

			    default:
				    return Reason;
		    }       
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
