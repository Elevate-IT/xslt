<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:s0="www.boltrics.nl/whseactlines:v1.00"
                xmlns:x="urn:schemas-microsoft-com:office:excel"
                xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
                xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/EDIFACT/2006"
                xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
                exclude-result-prefixes="msxsl var s0 MyScript" version="1.0">
  <xsl:output omit-xml-declaration="no" indent="yes"/>

  <xsl:key name="Group-by-CarrierNo" match="//s0:DocumentDetailLine" use="s0:CarrierNo" />
  <xsl:template match="/">
    <xsl:apply-templates select="//s0:WhseActivities" />
  </xsl:template>
  <xsl:template match="//s0:WhseActivities">
    <xsl:variable name="DetLineKey" select="//s0:DocumentDetailLine/s0:CarrierNo" />
    <xsl:processing-instruction name="mso-application">progid="Excel.Sheet"</xsl:processing-instruction>
    <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">
      <Styles>
        <Style ss:ID="s1">
          <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="21" ss:Bold="1"/>
        </Style>
        <Style ss:ID="s2">
          <Font ss:FontName="Calibri" ss:Size="11" ss:Bold="1"/>
        </Style>
        <Style ss:ID="s3">
          <Borders>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="11" ss:Bold="1" ss:Underline="Single" />
        </Style>
        <Style ss:ID="s4">
          <Borders>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
        </Style>
        <Style ss:ID="s5">
          <Borders>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
        </Style>
        <Style ss:ID="s6">
          <Alignment ss:Vertical="Center" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
        </Style>
        <Style ss:ID="s7">
          <Borders>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
        </Style>
        <Style ss:ID="s8">
          <Alignment ss:Vertical="Center" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
        </Style>
        <Style ss:ID="s9">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
        </Style>
        <Style ss:ID="s10">
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
        </Style>
        <Style ss:ID="s11">
          <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
            <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
          <Font ss:FontName="Calibri" ss:Size="11"/>
        </Style>
        <Style ss:ID="s12">
          <Alignment ss:Vertical="Center" ss:WrapText="1"/>
        </Style>
        <Style ss:ID="s13">
          <Alignment ss:Vertical="Center" ss:WrapText="1"/>
          <Borders>
            <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
          </Borders>
        </Style>
      </Styles>
      <Worksheet ss:Name="Reserved goods">
        <Table>
          <Column ss:Index="1" ss:Width="67"/>
          <Column ss:Index="2" ss:Width="92"/>
          <Column ss:Index="3" ss:Width="92"/>
          <Column ss:Index="4" ss:Width="92"/>
          <Column ss:Index="5" ss:Width="92"/>
          <Column ss:Index="6" ss:Width="15"/>
          <Column ss:Index="7" ss:Width="83"/>
          <Column ss:Index="8" ss:Width="82"/>
          <Column ss:Index="9" ss:Width="86"/>
          <Column ss:Index="10" ss:Width="27"/>
          <Column ss:Index="11" ss:Width="73"/>
          <Row ss:Index="2">
            <Cell ss:Index="1" ss:MergeAcross="10" ss:MergeDown="1" ss:StyleID="s1">
              <Data ss:Type="String">
                <xsl:value-of disable-output-escaping="yes" select="concat('Wonderful', '&amp;#10;', 'Reserved goods')" />
              </Data>
            </Cell>
          </Row>
          <Row ss:Index="3" ss:Height="47" />
          <Row ss:Index="5" ss:Height="14">
            <Cell ss:Index="1" ss:MergeAcross="1" ss:StyleID="s2">
              <Data ss:Type="String">Order nr Wonderful:</Data>
            </Cell>
            <Cell ss:Index="3" ss:MergeAcross="2">
              <Data ss:Type="String">
                <xsl:value-of select="//s0:Document/s0:ExternalReference" />
              </Data>
            </Cell>
            <Cell ss:Index="7" ss:StyleID="s2">
              <Data ss:Type="String">Reserved on:</Data>
            </Cell>
            <Cell ss:Index="8">
              <Data ss:Type="String">
                <xsl:value-of select="translate(MyScript:ParseDate(//s0:Document/s0:PostingDate, 'yyyy-MM-dd', 'dd/MM/yyyy'), '-', '/')" />
              </Data>
            </Cell>
          </Row>
          <Row ss:Index="6" ss:Height="14">
            <Cell ss:Index="1" ss:MergeAcross="1" ss:StyleID="s2">
              <Data ss:Type="String">Order nr IDP:</Data>
            </Cell>
            <Cell ss:Index="3" ss:MergeAcross="2">
              <Data ss:Type="String">
                <xsl:value-of select="//s0:Document/s0:ExternalDocumentNo" />
              </Data>
            </Cell>
            <Cell ss:Index="7" ss:StyleID="s2">
              <Data ss:Type="String">File number:</Data>
            </Cell>
            <Cell ss:Index="8">
              <Data ss:Type="String">
                <xsl:value-of select="//s0:Document/s0:No" />
              </Data>
            </Cell>
          </Row>
          <Row ss:Index="7" ss:Height="14">
            <Cell ss:Index="1" ss:MergeAcross="1" ss:StyleID="s2">
              <Data ss:Type="String">Forwarder:</Data>
            </Cell>
            <Cell ss:Index="3" ss:MergeAcross="3">
              <Data ss:Type="String"></Data>
            </Cell>
          </Row>
          <Row ss:Index="8" ss:Height="8" />
          <Row ss:Index="9" ss:Height="15">
            <Cell ss:Index="1" ss:MergeAcross="5" ss:StyleID="s3">
              <Data ss:Type="String">Principal</Data>
            </Cell>
            <Cell ss:Index="7" ss:MergeAcross="1" ss:StyleID="s3">
              <Data ss:Type="String">Consignee</Data>
            </Cell>
            <Cell ss:Index="9" ss:StyleID="s4" />
            <Cell ss:Index="10" ss:StyleID="s4" />
            <Cell ss:Index="11" ss:StyleID="s5" />
          </Row>
          <Row ss:Index="10" ss:Height="15">
            <Cell ss:Index="1" ss:MergeAcross="5" ss:StyleID="s6">
              <Data ss:Type="String">
                <xsl:value-of select="//s0:Document/s0:Customer/s0:Name" />
              </Data>
            </Cell>
            <Cell ss:Index="7" ss:MergeAcross="1" ss:StyleID="s12">
              <Data ss:Type="String">
                <xsl:value-of select="//s0:Document/s0:ShipToAddress/s0:Name" />
              </Data>
            </Cell>
            <Cell ss:Index="11" ss:StyleID="s7" />
          </Row>
          <Row ss:Index="11" ss:Height="15">
            <Cell ss:Index="1" ss:MergeAcross="5" ss:StyleID="s6">
              <Data ss:Type="String">
                <xsl:value-of select="//s0:Document/s0:Customer/s0:Address" />
              </Data>
            </Cell>
            <Cell ss:Index="7" ss:MergeAcross="1" ss:StyleID="s12">
              <Data ss:Type="String">
                <xsl:value-of select="//s0:Document/s0:ShipToAddress/s0:Address" />
              </Data>
            </Cell>
            <Cell ss:Index="11" ss:StyleID="s7" />
          </Row>
          <Row ss:Index="12" ss:Height="15">
            <Cell ss:Index="1" ss:MergeAcross="5" ss:StyleID="s6">
              <Data ss:Type="String">
                <xsl:value-of select="concat(//s0:Document/s0:Customer/s0:PostCode, '-', //s0:Document/s0:Customer/s0:City)" />
              </Data>
            </Cell>
            <Cell ss:Index="7" ss:MergeAcross="1" ss:StyleID="s12">
              <Data ss:Type="String">
                <xsl:value-of select="concat(//s0:Document/s0:ShipToAddress/s0:PostCode, '-', //s0:Document/s0:ShipToAddress/s0:City)" />
              </Data>
            </Cell>
            <Cell ss:Index="11" ss:StyleID="s7" />
          </Row>
          <Row ss:Index="13" ss:Height="30">
            <Cell ss:Index="1" ss:MergeAcross="5" ss:StyleID="s6">
              <Data ss:Type="String">
                <xsl:value-of select="//s0:Document/s0:Customer/s0:CountryName" />
              </Data>
            </Cell>
            <Cell ss:Index="7" ss:MergeAcross="1" ss:StyleID="s12">
              <Data ss:Type="String">
                <xsl:value-of select="//s0:Document/s0:ShipToAddress/s0:CountryRegionCode" />
              </Data>
            </Cell>
            <Cell ss:Index="11" ss:StyleID="s7" />
          </Row>
          <Row ss:Index="14" ss:Height="15">
            <Cell ss:Index="1" ss:MergeAcross="5" ss:StyleID="s6">
              <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:Index="7" ss:MergeAcross="1" ss:StyleID="s12">
              <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:Index="11" ss:StyleID="s7" />
          </Row>
          <Row ss:Index="15" ss:Height="30">
            <Cell ss:Index="1" ss:MergeAcross="5" ss:StyleID="s8">
              <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:Index="7" ss:MergeAcross="1" ss:StyleID="s13">
              <Data ss:Type="String">
                <xsl:value-of select="concat('Consignee Ref: ', //s0:Document/s0:ExternalReference)" />
              </Data>
            </Cell>
            <Cell ss:Index="9" ss:StyleID="s9">
              <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:Index="10" ss:StyleID="s9">
              <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:Index="11" ss:StyleID="s10">
              <Data ss:Type="String"></Data>
            </Cell>
          </Row>
          <Row ss:Index="16" ss:Height="10" />
          <Row ss:Index="17" ss:Height="19">
            <Cell ss:Index="1" ss:StyleID="s11">
              <Data ss:Type="String">Unit</Data>
            </Cell>
            <Cell ss:Index="2" ss:StyleID="s11">
              <Data ss:Type="String">Type</Data>
            </Cell>
            <Cell ss:Index="3" ss:StyleID="s11">
              <Data ss:Type="String">Product</Data>
            </Cell>
            <Cell ss:Index="4" ss:MergeAcross="3" ss:StyleID="s11">
              <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell ss:Index="8" ss:MergeAcross="1" ss:StyleID="s11">
              <Data ss:Type="String">Expire Date</Data>
            </Cell>
            <Cell ss:Index="10" ss:MergeAcross="1" ss:StyleID="s11">
              <Data ss:Type="String">Lot</Data>
            </Cell>
          </Row>
          <xsl:for-each select="//s0:WhseActivity/s0:Documents/s0:Document/s0:Carriers/s0:Carrier">
            <xsl:variable name="CustItem" select="s0:ContentLines/s0:CarrierContent/s0:CustomerItemNo" />
            <Row ss:Height="17">
              <Cell ss:Index="1" ss:StyleID="s11">
                <Data ss:Type="Number">
                  <xsl:value-of select="s0:ContentLines/s0:CarrierContent/s0:Quantity" />
                </Data>
              </Cell>
              <Cell ss:Index="2" ss:StyleID="s11">
                <Data ss:Type="String">
                  <xsl:value-of select="s0:ContentLines/s0:CarrierContent/s0:UnitofMeasureCode" />
                </Data>
              </Cell>
              <Cell ss:Index="3" ss:StyleID="s11">
                <Data ss:Type="String">
                  <xsl:value-of select="s0:ContentLines/s0:CarrierContent/s0:ExternalCustomerItemNo" />
                </Data>
              </Cell>
              <Cell ss:Index="4" ss:MergeAcross="3" ss:StyleID="s11">
                <Data ss:Type="String">
                  <xsl:value-of select="//s0:WhseActivity[s0:CustomerItemNo = $CustItem]/s0:Description" />
                </Data>
              </Cell>
              <Cell ss:Index="8" ss:MergeAcross="1" ss:StyleID="s11">
                <Data ss:Type="String">
                  <xsl:value-of select="translate(MyScript:ParseDate(s0:ContentLines/s0:CarrierContent/s0:ExpirationDate,'yyyy-MM-dd','dd/MM/yyyy'), '-', '/')" />
                </Data>
              </Cell>
              <Cell ss:Index="10" ss:MergeAcross="1" ss:StyleID="s11">
                <Data ss:Type="String">
                  <xsl:value-of select="s0:ContentLines/s0:CarrierContent/s0:ExBatchNo" />
                </Data>
              </Cell>
            </Row>
          </xsl:for-each>
        </Table>
        <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
          <PageSetup>
            <Layout x:Orientation="Landscape"/>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.5" x:Left="0.25" x:Right="0.25" x:Top="0.5"/>
          </PageSetup>
        </WorksheetOptions>
      </Worksheet>
    </Workbook>
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
      
      public string TrimEnd(string input)
      {
        return input.TrimEnd();
      }
      
      public int rowNr = 0;
      public string GetRowNr(int offset)
      {
        if (rowNr == 0)
          rowNr += offset;
          
        rowNr += 1;
          
        return rowNr.ToString();
      }

		]]>
  </msxsl:script>
</xsl:stylesheet>
