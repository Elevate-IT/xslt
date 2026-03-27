<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:MyScript="http://schemas.microsoft.com/BizTalk/2003/MyScript"
>
  <xsl:output method="text" omit-xml-declaration="yes" indent="no" />
  <xsl:strip-space elements="*" />

  <xsl:template match="*">
    <xsl:value-of select="MyScript:Replace(MyScript:RemoveDiacritics(current()), MyScript:PrintApos(), concat('?', MyScript:PrintApos()))" />
  </xsl:template>
  
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
      
      public string RemoveDiacritics(string text)
			{
				var normalizedString = text.Normalize(System.Text.NormalizationForm.FormD);
				var stringBuilder = new System.Text.StringBuilder();
				foreach (var c in normalizedString)
				{
					var unicodeCategory = System.Globalization.CharUnicodeInfo.GetUnicodeCategory(c);
					if (unicodeCategory != System.Globalization.UnicodeCategory.NonSpacingMark)
					{
						stringBuilder.Append(c);
					}
				}

				return stringBuilder.ToString().Normalize(System.Text.NormalizationForm.FormC);
			}
		]]>
  </msxsl:script>
</xsl:stylesheet>