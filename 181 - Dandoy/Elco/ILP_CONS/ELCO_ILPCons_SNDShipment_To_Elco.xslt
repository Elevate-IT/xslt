<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
    xmlns:ns0="www.boltrics.nl/sendshipment:v1.00">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
  <!--<xsl:strip-space elements="*" />-->
  <xsl:template match="/">
    <xsl:variable name="spaces">
      <xsl:value-of select="concat('                              ','')" />
    </xsl:variable>
    <xsl:variable name="zeros">
      <xsl:value-of select="'000000000000000000000000000000000'" />
    </xsl:variable>

    <!--EDI_DC40 Line (Control record structure)-->
    <xsl:value-of select="concat('EDI_DC40                           2   DELVRY03                                                    SHPCON                              E            SAP2SI    LISP', //ns0:Document/ns0:SenderReference, '                                                                                           SAPAIP    LS  SMPCLNT400                                                                                                                                                   ')"/>
    <xsl:value-of select="concat('ILP_CONS_', MyScript:GetCurrentDate('yyyyMMdd'), '_', //ns0:Document/ns0:ExternalDocumentNo, '.TXT')"/>
    <xsl:text>&#10;</xsl:text>

    <!--E2EDL20002 Line (Delivery header)-->
    <xsl:value-of select="concat('E2EDL20002','                                                     ', //ns0:Document/ns0:ExternalDocumentNo, '                                                                                                                    ')"/>
    <xsl:value-of select="concat(substring($zeros,1,16-string-length(//ns0:Document/ns0:Volume)),'CMQ', //ns0:Document/ns0:CarrierQuantity)"/>
    <xsl:text>&#10;</xsl:text>

    <!--E2EDL18 VOL (mandatory)-->
    <xsl:value-of select="concat('E2EDL18                                                        ', 'VOL')"/>
    <xsl:text>&#10;</xsl:text>

    <!--E2EDL18 VOL (mandatory)-->
    <xsl:value-of select="concat('E2EDL18                                                        ', 'PIC')"/>
    <xsl:text>&#10;</xsl:text>

    <!--E2EDL18 VOL (mandatory)-->
    <xsl:value-of select="concat('E2EDL18                                                        ', 'PGI')"/>
    <xsl:text>&#10;</xsl:text>

    <!--E2EDL18 DEL (nothing in stock)-->
    <xsl:if test="not(//ns0:DocumentLine/ns0:Quantity[not(.='0')])">
      <xsl:value-of select="concat('E2EDL18                                                        ', 'DEL')"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:if>

    <!--E2EDT13001 (Deadline)-->
    <xsl:value-of select="concat('E2EDT13001','                                                     ', '006', '                                                          ')"/>
    <xsl:value-of select="concat(MyScript:ParseDate(//ns0:Document/ns0:PlannedStartDate,'yyyy-MM-dd','yyyyMMdd'), '000000')" />
    <xsl:value-of select="concat(MyScript:ParseDate(//ns0:Document/ns0:PlannedStartDate,'yyyy-MM-dd','yyyyMMdd'), '000000')" />
    <xsl:text>&#10;</xsl:text>

    <!--E2EDL24006 (Article line)-->
    <xsl:for-each select="//ns0:DocumentLine">
      <xsl:value-of select="concat('E2EDL24006','                                                     ')"/>
      <xsl:value-of select="(ns0:Attributes/ns0:Attribute[ns0:Code='EXTLINENO']/ns0:Value)"/>
      <xsl:value-of select="ns0:ExternalNo"/>
      <xsl:value-of select="substring($spaces,1,18-string-length(ns0:ExternalNo))"/>
      <xsl:value-of select="'                                                                                                                                                        '"/>
      <xsl:choose>
        <xsl:when test="ns0:QtyCreated = '0' and ns0:ItemCondition = 'FATHER'">
          <xsl:variable name="FExternalNo">
            <xsl:value-of select="ns0:ExternalNo"/>
          </xsl:variable>
          <xsl:variable name="ArtQtyCreated">
            <xsl:value-of select="//ns0:DocumentLine[ns0:Attribute02=$FExternalNo]/ns0:QtyCreated"/>
          </xsl:variable>
          <xsl:if test="$ArtQtyCreated = 0">
            <xsl:value-of select="ns0:Quantity"/>
            <xsl:text>&#10;</xsl:text>
            <xsl:text>E2EDL19                                                        DEL&#10;</xsl:text>
          </xsl:if>
          <xsl:if test="not($ArtQtyCreated = 0)">
          </xsl:if>
          <xsl:value-of select="ns0:OrderQuantity div $ArtQtyCreated"/>
          <xsl:text>&#10;</xsl:text>
        </xsl:when>
        <xsl:when test="not(ns0:QtyCreated = '0')">
          <xsl:value-of select="ns0:QtyCreated"/>
          <xsl:text>&#10;</xsl:text>
          <xsl:if test="ns0:ItemCategoryCode = 'SERIALREQ'">
            <!--E2EDL11001 (Scanned serial number)-->
            <xsl:for-each select="ns0:DocumentDetailLines/ns0:DocumentDetailLine/ns0:SubCarriers/ns0:SubCarrier">
              <xsl:value-of select="concat('E2EDL11001','                                                                       ')"/>
              <xsl:value-of select="ns0:Attribute02"/>
              <xsl:text>&#10;</xsl:text>
            </xsl:for-each>
          </xsl:if>
        </xsl:when>
        <xsl:when test="ns0:QtyCreated = '0'">
          <xsl:value-of select="ns0:OrderQuantity"/>
          <xsl:text>&#10;</xsl:text>
          <xsl:text>E2EDL19                                                        DEL&#10;</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>


  <!--<xsl:value-of select="MyScript:Replace(current(), MyScript:PrintApos(), concat('?', MyScript:PrintApos()))" />-->
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			
      public string Replace(string input, string toReplace, string replaceTo)
			{
				return input.Replace(toReplace,replaceTo);
			}
      
      public string PrintApos()
			{
				return ((Char)8217).ToString();
			}
      
        public string ParseDate(string input, string formatIn, string formatOut)
      {
        if(System.String.IsNullOrEmpty(input)) return input;
        
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