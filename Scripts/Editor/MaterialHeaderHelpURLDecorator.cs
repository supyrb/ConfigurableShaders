// --------------------------------------------------------------------------------------------------------------------
// <copyright file="MaterialHelpURLDecorator.cs" company="Supyrb">
//   Copyright (c) 2019 Supyrb. All rights reserved.
// </copyright>
// <author>
//   Johannes Deml
//   send@johannesdeml.com
// </author>
// --------------------------------------------------------------------------------------------------------------------

using System;
using UnityEditor;
using UnityEngine;

namespace Supyrb
{
	/// <summary>
	/// Material Property Decorator [HeaderHelpURL] draws a Header with an help button on the right
	/// </summary>
	public class MaterialHeaderHelpURLDecorator : MaterialPropertyDrawer
	{
		private string url;
		private GUIContent headerGuiContent;
		private GUIContent buttonGuiContent;
		private const float iconWidth = 15f;
		private const float iconHeight = 20f;
		private const float paddingTop = 12f;
		

		/// <summary>
		/// Header with an help button on the right side with a linkk
		/// </summary>
		/// <param name="header">Header Text shown in bold</param>
		/// <param name="http">http or https</param>
		/// <param name="url">The url, but every "/" has to be replaced with a " " in order to work</param>
		public MaterialHeaderHelpURLDecorator(string header, string http, string url)
		{
			var sanatizedUrl = url.Replace(' ', '/');
			this.url = http + "://" + sanatizedUrl;
			var helpIcon = EditorGUIUtility.FindTexture("_Help");
			buttonGuiContent = new GUIContent(helpIcon, "Open Online Reference \n" + this.url);
			headerGuiContent = new GUIContent(header);
		}

		public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
		{
			var headerPosition = new Rect(position.x, position.y + paddingTop, position.width - iconWidth, iconHeight);
			var buttonPosition = new Rect(position.x + headerPosition.width, position.y + paddingTop, iconWidth, iconHeight);

			GUI.Label(headerPosition, headerGuiContent, EditorStyles.boldLabel);
			if (GUI.Button(buttonPosition, buttonGuiContent, EditorStyles.boldLabel))
			{
				Help.BrowseURL(this.url);
			}
		}

		public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
		{
			return iconHeight + paddingTop;
		}
	}
}