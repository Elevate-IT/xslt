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
    <xsl:variable name="APOS">&apos;</xsl:variable>
    <xsl:for-each select="Lines">
      <xsl:value-of select="MyScript:BuildEDIFACT(Line)" />
    </xsl:for-each>
    
    <xsl:value-of select="MyScript:SplitEDIFACT(MyScript:GetEDIFACT(), $APOS)" />
    <xsl:value-of select="MyScript:SetUNZSegment(MyScript:GetLastSplitEntry())" />

    <Messages>
      <xsl:call-template name="loop">
        <xsl:with-param name="i" select="number(0)"/>
        <xsl:with-param name="max" select="number(MyScript:GetSplitsLength()) - 1"/>
      </xsl:call-template>
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

  <xsl:template name="loop">
    <!--recursive loop until done-->
    <xsl:param name="i"/>
    <xsl:param name="max"/>
    <xsl:if test="$i &lt;= $max">
      <xsl:value-of select="MyScript:BuildMessage(MyScript:GetSplitEntry($i))" />
      <xsl:if test="substring(MyScript:GetSplitEntry($i), 1, 3) = 'UNT'">
        <Message>
          <xsl:value-of select="MyScript:WriteMessage()" />
        </Message>
        <xsl:value-of select="MyScript:ClearMessage()" />
      </xsl:if>

      <xsl:call-template name="loop">
        <xsl:with-param name="i" select="$i + 1"/>
        <xsl:with-param name="max" select="$max"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="MyScript">
    <![CDATA[
      string EDIFACT = "";
      string UNASegment = "";
      string UNBSegment = "";
      string UNZSegment = "";
      string Message = "";
      public string[] splits;
      
      public void BuildMessage(string Line)
      {
        if (Line != "") {
          if (Line.Substring(0, 3) == "UNA") {
            UNASegment = Line;
          }
          
          if (Line.Substring(0, 3) == "UNB") {
            UNBSegment = Line;
          }
        
          if (Line.Substring(0, 3) == "UNZ") {
            UNZSegment = Line;
          }
        
          if (Message == "") {
            if (UNASegment != "")
              Message += UNASegment;
            
            if (UNBSegment != "")
              Message += UNBSegment;
              
            if ((Line != UNASegment) && (Line != UNBSegment))
              Message += Line;
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
      
      public void SplitEDIFACT(string input, string seperator)
      {
        char[] charSeparators = new char[] { Convert.ToChar(seperator) };
        splits = input.Split(charSeparators, StringSplitOptions.RemoveEmptyEntries);
        
        for (int i = 0; i < splits.Length; i++)
        {
            splits[i] = splits[i] + charSeparators[0];
        }
      }
      
      public string GetLastSplitEntry()
      {
        if (splits[splits.Length - 1] != "")
          return splits[splits.Length - 1];
        else 
          return splits[splits.Length - 2];
      }
      
      public string GetSplitsLength()
      {
        return splits.Length.ToString();
      }
      
      public string GetSplitEntry(string index)
      {
        int i = Int32.Parse(index);
        return splits[i];
      }
      
      public void BuildEDIFACT(string part)
      {
        EDIFACT += part;
      }
      
      public string GetEDIFACT()
      {
        return EDIFACT;
      }
      
		]]>
  </msxsl:script>
</xsl:stylesheet>
