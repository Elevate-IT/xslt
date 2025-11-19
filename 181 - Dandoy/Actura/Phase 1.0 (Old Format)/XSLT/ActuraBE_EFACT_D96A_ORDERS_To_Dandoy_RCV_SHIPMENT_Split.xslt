<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
    exclude-result-prefixes="msxsl MyScript">
  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="TextLines"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/TextLines">
    <xsl:choose>
      <xsl:when test="Lines[last()]/Line != ''">
        <xsl:value-of select="MyScript:SetUNZSegment(Lines[last()]/Line)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="MyScript:SetUNZSegment(Lines[last()-1]/Line)" />
      </xsl:otherwise>
    </xsl:choose>

    <Messages>
      <xsl:apply-templates select="Lines"/>    
    </Messages>
  </xsl:template>

  <xsl:template match="/TextLines/Lines">
    <xsl:value-of select="MyScript:BuildMessage(Line)" />
    <xsl:if test="substring(Line, 1, 3) = 'UNT'">
      <Message>
        <xsl:value-of select="MyScript:WriteMessage()" />
      </Message>
      <xsl:value-of select="MyScript:ClearMessage()" />
    </xsl:if>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[			
      string UNBSegment = "";
      string UNZSegment = "";
      string Message = "";
      
      public void BuildMessage(string Line)
      {
        if (Line != "") {          
          if (Line.Substring(0, 3) == "UNB") {
            UNBSegment = Line;
          }
        
          if (Line.Substring(0, 3) == "UNZ") {
            UNZSegment = Line;
          }
        
          if (Message == "") {
            Message += UNBSegment;
            if (Line != UNBSegment) {
              Message += Line;
            }
          } else {
            Message += Line;
          }
        }
      }
      
      public string WriteMessage()
      {
        Message += UNZSegment;
        return Message;
      }
      
      public void ClearMessage()
      {
        Message = "";
      }
      
      public void SetUNZSegment(string Line)
      {
        if (Line.Length >= 3) {
          if (Line.Substring(0, 3) == "UNZ") {
            UNZSegment = Line;
          }
        }
      }
      
		]]>
  </msxsl:script>
</xsl:stylesheet>
