// --------------------------------------------------------------------------------------------------------------------
// <copyright file="EightBitDrawer.cs" company="Supyrb">
//   Copyright (c)  Supyrb. All rights reserved.
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
	public class EightBitDrawer : MaterialPropertyDrawer
	{
		private GUIContent guiContent;
		private const string tooltip = "Value between 0 and 255";

		public EightBitDrawer()
		{
			this.guiContent = new GUIContent(string.Empty, tooltip);
		}
		
		public override void OnGUI (Rect position, MaterialProperty prop, String label, MaterialEditor editor)
		{
			guiContent.text = label;
			float value = prop.floatValue;
			int intValue = (int)value;

			EditorGUI.BeginChangeCheck();
			EditorGUI.showMixedValue = prop.hasMixedValue;

			intValue = EditorGUI.IntField(position, guiContent, intValue);
			intValue = Mathf.Clamp(intValue, 0, 255);
			value = (float) intValue;

			EditorGUI.showMixedValue = false;
			if (EditorGUI.EndChangeCheck())
			{
				prop.floatValue = value;
			}
		}
	}
}