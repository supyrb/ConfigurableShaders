// --------------------------------------------------------------------------------------------------------------------
// <copyright file="MaterialRangeMapperDrawer.cs" company="Supyrb">
//   Copyright (c) 2019 Supyrb. All rights reserved.
// </copyright>
// <author>
//   Johannes Deml
//   public@deml.io
// </author>
// --------------------------------------------------------------------------------------------------------------------

using System;
using UnityEditor;
using UnityEngine;

namespace Supyrb
{
	public class MaterialRangeMapperDrawer : MaterialPropertyDrawer
	{
		private GUIContent guiContent;
		private GUIContent inGuiContent;
		private GUIContent outGuiContent;
		private const string tooltip = "x:Lower Input, y:Upper Input, z:Lower Output, w:Upper Output";
		private const float labelWidth = 100f;
		private const float innerLabelWidth = 30f;
		private float lineHeight;
		private Rect firstLine;
		private Rect secondLine;

		public MaterialRangeMapperDrawer()
		{
			guiContent = new GUIContent(string.Empty, tooltip);
			inGuiContent = new GUIContent("In");
			outGuiContent = new GUIContent("Out");
			lineHeight = EditorGUIUtility.singleLineHeight;
			firstLine = new Rect();
			secondLine = new Rect();
		}

		public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
		{
			var previousLabelWidth = EditorGUIUtility.labelWidth;

			guiContent.text = label;
			var value = prop.vectorValue;
			var inRange = new Vector2(value.x, value.y);
			var outRange = new Vector2(value.z, value.w);

			var singleFieldWidth = (position.width - labelWidth - innerLabelWidth) * 0.75f;
			firstLine.Set(position.x + labelWidth, position.y,  singleFieldWidth * 2f + innerLabelWidth, lineHeight);
			secondLine.Set(firstLine.x, position.y + lineHeight, firstLine.width, lineHeight);


			EditorGUI.BeginChangeCheck();
			EditorGUI.showMixedValue = prop.hasMixedValue;

			EditorGUIUtility.labelWidth = labelWidth;
			EditorGUI.LabelField(position, guiContent);
			
			EditorGUIUtility.labelWidth = innerLabelWidth;
			inRange = EditorGUI.Vector2Field(firstLine, inGuiContent, inRange);
			outRange = EditorGUI.Vector2Field(secondLine, outGuiContent, outRange);

			EditorGUI.showMixedValue = false;

			if (EditorGUI.EndChangeCheck())
			{
				value.x = inRange.x;
				value.y = inRange.y;
				value.z = outRange.x;
				value.w = outRange.y;
				prop.vectorValue = value;
			}
			
			EditorGUIUtility.labelWidth = previousLabelWidth;
		}

		public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
		{
			return this.lineHeight * 2.0f;
		}
	}
}